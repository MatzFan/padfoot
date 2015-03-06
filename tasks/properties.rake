namespace :sq do
  namespace :props do
    desc "Populates properties table"
    task :all do
      properties = PropertyScraper.new('JE3 8HP').data.map do |data_array|
        uprn, add = data_array
        Property.new(uprn: uprn, prop_html: add[0], road: add[1],
          parish_num: add[2], p_code: add[3])
      end
      properties.each { |p| p.x, p.y = CoordScraper.new(p.uprn).x_y_coords }
      DB.transaction { properties.map &:save }
    end
  end
end
