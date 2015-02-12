Padfoot::App.controllers :planning_app do

  before { redirect('/login') unless signed_in? }

  get :index, map: '/applications/index', provides: [:html, :json] do
    apps = all_apps_ordered
    parishes = []
    DB.transaction { parishes = apps.map &:parish }
    columns = [
      :order, :valid_date, :app_ref, :app_code, :app_status, :app_full_address,
      :app_description, :app_address_of_applicant, :app_agent, :app_officer]
    @titles = columns.map { |c| c.to_s.split('_').last.capitalize }
    @app_arr = apps.select_map(columns) # 2D array
    @titles << 'Parish'
    @app_arr.each_with_index { |arr, i| arr = arr << parishes[i] }
    # wrap txt in <div>s and add class to app_description for css formatting
    classes_to_add = columns.map { |c| 'long-text' if c == :app_description }
    @app_arr.map! { |app| div_wrap_strings_in(app, classes_to_add) }
    case content_type
    when :json
      { columns: @titles.map { |t| { title: t } }, app_data: @app_arr }.to_json
    when :html
      render :index
    else
    end
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

end
