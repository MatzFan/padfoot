namespace :sq do
  namespace :apps do
    desc "Saves all planning applications"
    task :save do
      DB.transaction { PlanningApp.all.each &:save }
    end
  end
end
