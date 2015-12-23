describe BusStop do

  extend Mappable

  context '#set_geom' do
    it 'sets to geom field to a SRID 3109 x, y geometry point from lat, long' do
      bs = BusStop.new(code: '1234', name: 'Test', latitude: 49.183531, longitude: -2.110287)
      bs.valid?
      expect(bs.geom).to eq(DB["SELECT ST_SetSRID(ST_Point(41801.640914, 65388.373852),3109)::geometry"])
    end
  end

end
