module Mappable

  def coords(lat, long)
    res = DB["SELECT ST_AsGeoJSON(ST_Transform(ST_SetSRID(ST_MakePoint(
      #{long}, #{lat}), 4326), 3109))"].first[:st_asgeojson]
    JSON.parse(res)['coordinates'].map { |c| c.round(6) }
  end

  def lat_long(x, y)
    res = DB["SELECT ST_AsGeoJSON(ST_Transform(ST_SetSRID(ST_MakePoint(
      #{x}, #{y}), 3109), 4326))"].first[:st_asgeojson]
    JSON.parse(res)['coordinates'].reverse.map { |c| c.round(6) }
  end

  def line_string(lats, longs)
    cartesians = lats.zip(longs).map { |arr| self.coords(arr[0], arr[1]) }
    "'LINESTRING(#{cartesians.map { |coords| coords.join(' ') }.join(', ')})'"
  end

  def within_circle(lat, long, radius) # radius in meters
    circle = "ST_Buffer(ST_Transform(ST_SetSRID(ST_MakePoint(#{long}, #{lat}), 4326), 3109), #{radius})::geometry"
    ds = DB["SELECT * from #{self.table_name} WHERE ST_Contains(#{circle}, #{self.table_name}.geom)"].all
    ds.map { |hash| self.new(hash) }
  end

  def within_polygon(lats, longs)
    polygon = "ST_SetSRID(ST_MakePolygon(ST_GeomFromText(#{self.line_string(lats, longs)})), 3109)::geometry"
    ds = DB["SELECT * from #{self.table_name} WHERE ST_Contains(#{polygon}, #{self.table_name}.geom)"].all
    ds.map { |hash| self.new(hash) }
  end

  def nearest_to(x, y)
    self.new(DB["SELECT * FROM #{self.table_name} ORDER BY geom <-> 'SRID=3109;POINT(#{x} #{y})'::geometry LIMIT 1"].first)
  end

  def within_x_meters_of(x, lat, long) # works for Property model only
    DB["SELECT * FROM #{self.table_name} WHERE (ST_DWithin(ST_GeographyFromText(
      'SRID=4326;POINT(
      ' || #{self.table_name}.prop_long || ' ' || #{self.table_name}.prop_lat || ')'),
      ST_GeographyFromText('SRID=4326;POINT(#{long} #{lat})'), #{x}))"
    ].map { |h| self.new(h) }
  end

end
