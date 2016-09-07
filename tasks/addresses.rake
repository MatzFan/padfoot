require_relative '../lib/scrapers/address_scraper'

namespace :sq do
  namespace :adds do
    desc 'Populates addresses table with Jersey addresses from postcodes'
    task all: :environment do
      Postcode.select_map(:code).each_slice(100) do |codes_slice|
        addresses = codes_slice.map do |code|
          AddressScraper.new(code).addresses.map do |a|
            Address.new(html: a[0], road: a[1], parish_num: a[2], p_code: a[3])
          end
        end.flatten
        # DB.transaction { addresses.each(&:save) }
      end
    end
  end
end
