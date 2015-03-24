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

  get :map, map: 'applications/map' do
    gon.data = []
    render :map
  end

  post :map, map: 'applications/map' do
    @all_refs = params[:tableData].split("\r\n") if params[:tableData]
    apps = PlanningApp.where(:mapped, app_ref: @all_refs).all
    gon.data = PlanningApp.pin_data_hash(apps)
    render :map
  end

  get :within_circle, map: 'applications/within_circle', provides: :json do
    lat, long, radius = params[:lat], params[:long], params[:radius]
    apps = PlanningApp.within_circle(lat.to_f, long.to_f, radius.to_f)
    PlanningApp.pin_data_hash(apps).to_json
  end

  get :within_polygon, map: 'applications/within_polygon', provides: :json do
    lats, longs = params[:lats], params[:longs]
    apps = PlanningApp.within_polygon(PlanningApp.transform(lats, longs))
    PlanningApp.pin_data_hash(apps).to_json
  end

end
