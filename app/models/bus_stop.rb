class BusStop < Sequel::Model

  extend Mappable

  unrestrict_primary_key

  def before_validation
    self.geom = set_geom(self.latitude, self.longitude)
    super
  end

  def set_geom(lat, long)
    x, y = self.class.coords(lat, long) # .coords from Mappable module
    self.geom = DB["SELECT ST_SetSRID(ST_Point(#{x}, #{y}),3109)::geometry"]
  end

end
