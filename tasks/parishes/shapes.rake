namespace :sq do
  namespace :parishes do
    desc "Populates parishes table with shape geometry"
    task :shapes do
      scraper = ParishScraper.new(1, 1)
      parish_num = scraper.data[0][:parish] # replace 0 with i if iterating parishes
      rings = scraper.rings.first # assuming 1 ring
      parish = Parish[parish_num]
      parish.geom = DB["SELECT #{Parish.polygon(rings)}"]
      parish.save
    end
  end
end
