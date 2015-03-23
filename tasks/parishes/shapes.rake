namespace :sq do
  namespace :parishes do
    desc "Populates parishes table with shape geometry"
    task :shapes do
      (1..12).each do |i|
        parish = Parish[i]
        object_id_array = ParishScraper.const_get(:OBJ_IDS)[i - 1]
        parish_rings = object_id_array.map do |id|
          scraper = ParishScraper.new(id, id)
          data = scraper.data[0]
          raise Error if data[:parish] != i || data[:object_id] != id
          scraper.rings[0]
        end
        parish.geom = Parish.multipolygon(parish_rings)
        parish.save
      end
    end
  end
end
