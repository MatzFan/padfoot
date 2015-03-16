namespace :sq do
  namespace :props do
    desc "Saves all properties"
    task :save do
      DB.transaction { Property.all.each &:save }
    end
  end
end
