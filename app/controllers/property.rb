Padfoot::App.controllers :property do

  before { redirect('/login') unless signed_in? }

  get :map, map: 'properties/map' do
    gon.data = nil
    render :map
  end

  get :within_circle, map: 'properties/within_circle', provides: :json do
    lat, long, radius = params[:lat], params[:long], params[:radius]
    # apps = Property.within_circle(lat.to_f, long.to_f, radius.to_f)
    # pin_data_hash(apps).to_json # helper method
  end

  # get :within_polygon, map: 'applications/within_polygon', provides: :json do
  #   lats, longs = params[:lats], params[:longs]
  #   apps = PlanningApp.within_polygon(lats, longs)
  #   pin_data_hash(apps).to_json # helper method
  # end

end
