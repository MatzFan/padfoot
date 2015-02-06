class Parish < Sequel::Model

  unrestrict_primary_key

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

end
