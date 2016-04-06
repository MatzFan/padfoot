Padfoot::App.controllers :property do
  before { redirect('/login') unless signed_in? }

  get :index, map: 'properties/index', provides: [:html, :json] do
    @arr = DB[:property_owners].map(&:values)
    @titles = Property::TABLE_TITLES
    json = { columns: @titles.map { |t| { title: t } }, app_data: @arr }.to_json
    content_type == :json ? json : render(:index) # assume html
  end

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
    Parish.exclude(geom: nil).all.map do |parish|
      ring_strings = parish.to_geog.split(')))').first.split('MULTIPOLYGON(((').last.split('),(')
      ring_strings.map { |ring| ring.split(',').map { |coords| coords.split(' ').reverse } }
    end.to_json
  end
end
