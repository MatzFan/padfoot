class Parish < Sequel::Model

  extend Mappable

  unrestrict_primary_key
  one_to_many :parish_aliases, key: :number
  one_to_many :addresses
  one_to_many :properties

  NAMES = [
    'Grouville',
    'St. Brelade',
    'St. Clement',
    'St. Helier',
    'St. John',
    'St. Lawrence',
    'St. Martin',
    'St. Mary',
    'St. Ouen',
    'St. Peter',
    'St. Saviour',
    'Trinity'
  ]

  def contains?(object)
    DB["SELECT ST_Contains(ST_GeomFromText(ST_AsText('#{self.geom}')), ST_GeomFromText(ST_AsText('#{object.geom}')))"].first[:st_contains]
  end

end
