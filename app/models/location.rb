class Location < Sequel::Model

  unrestrict_primary_key

  def before_save
    self.loc_lat, self.loc_long = coords(self.x, self.y) if self.x && self.y
    super
  end

  def coords(x, y)
    gis_pt = JTM_FACTORY.point(x, y)
    wgs_pt = RGeo::Feature.cast(gis_pt, factory: WGS84_FACTORY, project: true)
    [wgs_pt.y.round(6), wgs_pt.x.round(6)]
  end

end
