class Property < Sequel::Model

  unrestrict_primary_key
  many_to_one :postcode, key: :p_code
  many_to_one :parish, key: :parish_num
  many_to_one :road_name, key: :road
  many_to_one :property_type, key: :type

  def before_save
    DB.transaction do
      PropertyType.find_or_create(name: self.type) if self.type
      RoadName.find_or_create(name: self.road) if self.road
      Postcode.find_or_create(code: self.p_code) if self.p_code
    end
    self.prop_lat, self.prop_long = coords(self.x, self.y) if self.x && self.y
    super
  end

  def coords(x, y)
    res = DB["SELECT ST_AsGeoJSON(ST_Transform(ST_SetSRID(ST_MakePoint(#{x}, #{y}), 3109), 4326))"]
    JSON.parse(res.first[:st_asgeojson])['coordinates'].reverse.map { |c| c.round(6) }
  end

  # def coords(x, y)
  #   gis_pt = JTM_FACTORY.point(x, y)
  #   wgs_pt = RGeo::Feature.cast(gis_pt, factory: WGS84_FACTORY, project: true)
  #   [wgs_pt.y.round(6), wgs_pt.x.round(6)]
  # end

end
