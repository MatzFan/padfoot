class Address < Sequel::Model

  many_to_one :postcode, key: :p_code
  many_to_one :parish, key: :parish_num
  many_to_one :road_name, key: :road

  def before_save
    DB.transaction do
      RoadName.find_or_create(name: self.road) if self.road
      Postcode.find_or_create(code: self.p_code) if self.p_code
    end
    super
  end

end
