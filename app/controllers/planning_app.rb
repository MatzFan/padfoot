Padfoot::App.controllers :planning_app do

  before { redirect('/login') unless signed_in? }

  get :index, map: '/applications/index', provides: [:html, :json] do
    apps = all_apps_ordered
    columns = [
      :order, :valid_date, :app_ref, :app_code, :app_status, :app_full_address,
      :app_description, :app_address_of_applicant, :app_agent, :app_officer,
      :parish, :list_app_constraints, :list_app_meetings]
    @titles = columns.map { |c| c.to_s.split('_').last.capitalize }
    @app_arr = apps.select_map(columns) # 2D array
    classes_to_add = columns.map { |c| 'long-text' if c == :app_description }
    # wrap txt in <div>s and add class to app_description for css formatting
    @app_arr.map! { |app| div_wrap_strings_in(app, classes_to_add) }
    json = { columns: @titles.map { |t| { title: t } }, app_data: @app_arr }.to_json
    content_type == :json ? json : render(:index) # assume html
  end

  post :map, map: 'applications/map' do
    @all_refs = params[:tableData].split("\r\n") if params[:tableData]
    apps = PlanningApp.where(:mapped, app_ref: @all_refs)
    statuses = Status.to_hash(:name, :colour)
    categories = Category.to_hash(:code, :letter)
    gon.colours = apps.select_map(:app_status).map { |s| statuses[s] }
    gon.letters = apps.select_map(:app_category).map { |c| categories[c] }
    gon.locations = apps.select_map([:latitude, :longitude])
    gon.refs = apps.select_map(:app_ref)
    gon.descrips = apps.select_map(:app_description).map { |t| trunc(t, 20) }
    render :map
  end

  get :within, map: 'applications/within', provides: :json do
    lat, long, radius = params[:lat], params[:long], params[:radius]
    apps = PlanningApp.within_circle(lat.to_f, long.to_f, radius.to_f)
    cols = [{ref: :app_ref}, {desc: :app_description}, {lat: :latitude}, {long: :longitude}]
    arr = apps.map { |app| cols.map(&:values).flatten.map { |col| app.send(col) } }
    arr.map { |arr| cols.map(&:keys).flatten.zip(arr).to_h }.to_json
  end

end
