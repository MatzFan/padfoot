namespace :sq do
  namespace :props do
    desc 'Populates properties table from Digimap Gazetteer layer'
    task :all do
      data = GazetteerScraper.new.all_data
      Transaction do
        data.map do |h| # update or create each
          (p = Property[h[:uprn]]) ? p.update(h) : Property.create(h)
        end
      end
    end
  end
end
