namespace :sq do
  namespace :parishes do
    desc "Populates parishes table with shape geometry"
    task :shapes do
      scraper = ParishScraper.new(17, 17)
      parish_num = scraper.data[0][:parish] # replace 0 with i if iterating parishes
      rings = scraper.rings
      parish = Parish[parish_num]
      parish.geom = Parish.multipolygon(rings)
      parish.save
    end
  end
end
