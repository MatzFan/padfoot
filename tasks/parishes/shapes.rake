namespace :sq do
  namespace :parishes do
    desc "Populates parishes table with shape geometry"
    task :shapes do
      [1,3,4,6,8,11,12,17].each do |id| # obejct_ids
        scraper = ParishScraper.new(id, id)
        parish_num = scraper.data[0][:parish]
        rings = scraper.rings
        parish = Parish[parish_num]
        parish.geom = Parish.multipolygon(rings)
        parish.save
      end
    end
  end
end
