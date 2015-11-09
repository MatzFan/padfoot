class Property < Sequel::Model

  extend Mappable
  extend PushpinPlottable

  unrestrict_primary_key
  one_to_one :trans_prop, key: :property_uprn
  many_to_one :postcode, key: :p_code
  many_to_one :parish, key: :parish_num
  many_to_one :road_name, key: :road
  many_to_one :property_type, key: :type

  PUSHIN_COLUMNS = [:vingtaine, :road, :road, :address1, :prop_lat, :prop_long]

  def before_save
    DB.transaction do
      PropertyType.find_or_create(name: self.type) if self.type
      RoadName.find_or_create(name: self.road) if self.road
      Postcode.find_or_create(code: self.p_code) if self.p_code
    end
    if self.x && self.y
      self.prop_lat, self.prop_long = self.class.lat_long(self.x, self.y)
      self.geom = DB["SELECT ST_SetSRID(ST_Point(#{self.x}, #{self.y}),3109)::geometry"]
    end
    super
  end

  def self.pushpin_colours_hash

  end

  def self.pushpin_letters_hash

  end

end
