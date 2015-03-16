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
    self.prop_lat, self.prop_long = self.class.coords(self.x, self.y) if self.x && self.y
    self.geom = DB["SELECT ST_SetSRID(ST_Point(#{self.x}, #{self.y}),3109)::geometry"]
    super
  end

  def self.nearest_to(x, y)
    Property.new(DB["SELECT * FROM properties ORDER BY geom <-> '
      SRID=3109;POINT(#{x} #{y})'::geometry LIMIT 1"].first)
  end

  def self.within_x_meters_of(x, lat, long)
    DB["SELECT * FROM \"properties\" WHERE (ST_DWithin(ST_GeographyFromText(
      'SRID=4326;POINT(
      ' || properties.prop_long || ' ' || properties.prop_lat || ')'),
      ST_GeographyFromText('SRID=4326;POINT(#{long} #{lat})'), #{x}))"
    ].map { |h| Property.new(h) }
  end

  def self.coords(x, y)
    res = DB["SELECT ST_AsGeoJSON(ST_Transform(ST_SetSRID(ST_MakePoint(
      #{x}, #{y}), 3109), 4326))"].first[:st_asgeojson]
    JSON.parse(res)['coordinates'].reverse.map { |c| c.round(6) }
  end

  # def coords(x, y)
  #   gis_pt = JTM_FACTORY.point(x, y)
  #   wgs_pt = RGeo::Feature.cast(gis_pt, factory: WGS84_FACTORY, project: true)
  #   [wgs_pt.y.round(6), wgs_pt.x.round(6)]
  # end

end
