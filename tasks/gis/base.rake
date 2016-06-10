namespace :sq do
  namespace :gis do
    desc 'Creates and populates the buildings table'
    task :base, [:index] do |_t, args|
      args.with_defaults(index: nil)
      server = 'http://gis.digimap.je/ArcGIS/rest/services/JsyBase/MapServer/'
      GisScraper.configure(dbname: 'jersey', srs: 'EPSG:3109')
      range = args.index ? (args.index.to_i..args.index.to_i) : (32..40)
      range.each do |n|
        DB.transaction do
          Layer.new("#{server}#{n}").output_to_db
        end
      end
    end
  end
end
