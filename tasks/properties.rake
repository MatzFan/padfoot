namespace :sq do
  namespace :props do
    desc "Populates properties table"
    task :all do
      properties = PropertyScraper.new('JE3 8HP').data.map do |data_array|
        uprn, add = data_array
        Property.new(uprn: uprn, prop_html: add[0])
      end
      DB.transaction do
        properties.map &:save
      end
    end
  end
end
