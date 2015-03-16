namespace :sq do
  namespace :props do
    desc "Populates properties geog column"
    task :save do
      DB.transaction { Property.all.each &:save }
    end
  end
end
