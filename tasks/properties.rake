namespace :sq do
  namespace :props do
    desc "Populates properties table"
    task :all do
      num_props = PropertyScraper.new.num_props
      (1..27).each_slice.(10).map do

      end
      # DB.transaction { properties.map &:save }
    end
  end
end
