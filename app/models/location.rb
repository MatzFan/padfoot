class Location < Sequel::Model

  unrestrict_primary_key

  def before_save
    self.loc_lat, self.loc_long = coords(self.x, self.y)
    super
  end

  def coords(x, y)
    res = DB["SELECT ST_AsGeoJSON(ST_Transform(ST_SetSRID(ST_MakePoint(#{x}, #{y}), 3109), 4326))"]
    JSON.parse(res.first[:st_asgeojson])['coordinates'].reverse
  end

end
