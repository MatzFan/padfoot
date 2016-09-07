namespace :sq do
  namespace :apps do
    desc 'Pre-populate the parishes table with the 12 parishes'
    task parishes: :environment do
      DB.transaction do
        Parish::NAMES.each_with_index do |name, i|
          Parish.create(number: i + 1, name: name)
        end
      end
    end
  end
end
