namespace :sq do
  namespace :postcodes do
    desc "Populates postcodes table with valid Jersey postcodes"
    task :all do
      DB.transaction { Postcode.const_get(:CODES).each { |code| Postcode.create(code: code) } }
    end
  end
end
