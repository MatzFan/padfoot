namespace :sq do
  namespace :apps do
    desc "Pre-populate the parishes and parishes_parish_aliases tables with the 12 parishes"
    task :parishes do
      DB.transaction do
        Parish::NAMES.each_with_index do |name, i|
          Parish.create(number: i + 1, name: name)
          DB[:parishes_parish_aliases].insert(number: i + 1, name: name)
        end
      end
    end
  end
end
