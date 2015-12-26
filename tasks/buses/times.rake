namespace :sq do
  namespace :buses do
    desc "Adds all bus stops from BusStopParser"
    task :times do
      s = BusTimetableScraper.new
      (0...s.num_routes).each do |route|
        DB.transaction do
        # column like this: Time :time, only_time: true
        # Sequel::SQLTime.create(*t.split(':'), 00) => hh:mm:ss
        end
      end
    end
  end
end
