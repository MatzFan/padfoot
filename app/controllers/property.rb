Padfoot::App.controllers :property do

  before { redirect('/login') unless signed_in? }

  get :map, map: 'properties/map' do
    gon.data = []
    render :map
  end

  get :within_circle, map: 'properties/within_circle', provides: :json do
    lat, long, radius = params[:lat], params[:long], params[:radius]
    props = Property.within_circle(lat.to_f, long.to_f, radius.to_f)
    Property.pin_data_hash(props).to_json # helper method
  end

  get :within_polygon, map: 'properties/within_polygon', provides: :json do
    lats, longs = params[:lats], params[:longs]
    props = Property.within_polygon(Property.transform(lats, longs))
    Property.pin_data_hash(props).to_json
  end

  get :parishes, map: 'properties/parishes', provides: :json do
    xys = DB["SELECT ST_AsText('#{Parish[3].geom}')"].first[:st_astext].split('((').last.split('))').first.split(',').map { |s| s.split(' ')}
    xs, ys = xys.map(&:first), xys.map(&:last)
    Property.transform_xy(xs, ys).to_json
  end

end
