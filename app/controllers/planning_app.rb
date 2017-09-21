Padfoot::App.controllers :planning_app do
  before { redirect('/login') unless signed_in? }

  get :index, map: 'applications/index', provides: %i[html json] do
    content_type == :json ? table_apps_json(params[:refs]) : render(:index)
  end

  post :index, map: 'applications/index' do
    gon.refs = params[:refs]
    render(:index)
  end

  get :map, map: 'applications/map' do
    gon.data = []
    @show_location_finder = true
    render :map
  end

  post :map, map: 'applications/map' do
    @all_refs = params[:tableData].split("\r\n") if params[:tableData]
    apps = PlanningApp.where(mapped: true, app_ref: @all_refs).all
    gon.data = PlanningApp.pin_data_hash(apps)
    render :map
  end

  get :find_location, map: 'applications/map/find_location', provides: :json do
    geolocate(params[:search_string]).to_json if params[:search_string]
  end

  get :address, map: 'applications/description', provides: :json do
    PlanningApp[params[:ref]].app_description.to_json
  end

  get :within_circle, map: 'applications/within_circle', provides: :json do
    lat = params[:lat]
    long = params[:long]
    radius = params[:radius]
    apps = PlanningApp.within_circle(lat.to_f, long.to_f, radius.to_f)
    PlanningApp.pin_data_hash(apps).to_json
  end

  get :within_polygon, map: 'applications/within_polygon', provides: :json do
    lats = params[:lats]
    longs = params[:longs]
    apps = PlanningApp.within_polygon(PlanningApp.transform(lats, longs))
    PlanningApp.pin_data_hash(apps).to_json
  end
end
