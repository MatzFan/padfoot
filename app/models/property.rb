# a Gazetteer entry
class Property < Sequel::Model
  extend Mappable
  extend PushpinPlottable

  TABLE_TITLES = %w(UPRN Name_Id Date Type).freeze

  unrestrict_primary_key
  one_to_one :trans_prop, key: :property_uprn
  many_to_one :postcode, key: :p_code
  many_to_one :parish, key: :parish_num
  many_to_one :road_name, key: :road
  many_to_one :property_type, key: :type
  many_to_one :island, key: :island_name

  PUSHIN_COLUMNS = [:vingtaine, :road, :road, :address1,
                    :prop_lat, :prop_long].freeze

  def before_save
    update_parent_tables
    if x && y
      self.prop_lat, self.prop_long = self.class.lat_long(x, y)
      self.geom = DB["SELECT ST_SetSRID(ST_Point(#{x}, #{y}),3109)::geometry"]
    end
    super
  end

  def update_parent_tables
    DB.transaction do
      PropertyType.find_or_create(name: type) if type
      RoadName.find_or_create(name: road) if road
      Postcode.find_or_create(code: p_code) if p_code
      Island.find_or_create(name: island_name) if island_name
    end
  end
end
