namespace :sq do
  namespace :props do
    desc 'Populates properties table from Digimap Gazetteer layer'
    task :all do
      num_props = GazetteerScraper.new.num_records
      DB.transaction do
        (1..num_props).each_slice(1000).map do |arr|
          data = GazetteerScraper.new(arr[0], arr[-1]).data
          data.map do |h| # update or create each
            (p = Property[h[:uprn]]) ? p.update(h) : Property.create(h)
          end
        end
      end
    end
  end
end
