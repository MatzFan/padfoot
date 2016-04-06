Padfoot::App.controllers :planning_app do
  before { redirect('/login') unless signed_in? }

  get :index, map: 'applications/index', provides: [:html, :json] do
    refs = params[:refs] # a comma separated string of app_refs
    apps = refs ? apps_ordered(refs.split(',')) : all_apps_ordered # helpers
    # @titles = PlanningApp::TABLE_COLS.map { |c| c.to_s.split('_').last.capitalize }
    @titles = PlanningApp::TABLE_TITLES
    @app_arr = apps.select_map(PlanningApp::TABLE_COLS) # 2D array
    @app_arr.first.inspect
    # classes_to_add = PlanningApp::TABLE_COLS.map { |c| 'long-text' if c == :app_description }
    # # wrap txt in <div>s and add class to app_description for css formatting
    # @app_arr.map! { |app| div_wrap_strings_in(app, classes_to_add) }
    # json = { columns: @titles.map { |t| { title: t } }, app_data: @app_arr }.to_json
    # content_type == :json ? json : render(:index) # assume html
  end

  post :index, map: 'applications/index' do
    gon.refs = params[:refs]
    render(:index)
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

  get :address, map: 'applications/description', provides: :json do
    PlanningApp[params[:ref]].app_description.to_json
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
