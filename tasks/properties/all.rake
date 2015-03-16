namespace :sq do
  namespace :props do
    desc "Populates properties table"
    task :all do
      num_props = PropertyScraper.new.num_props
      arr = (1..num_props).each_slice(1000).map do |arr|
        data = PropertyScraper.new(arr[0], arr[-1]).data
        properties = data.map { |hash| Property.new(hash) }
        DB.transaction { properties.map &:save }
      end
    end
  end
end
