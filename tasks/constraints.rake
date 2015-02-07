namespace :sq do
  namespace :apps do
    desc "Populate the constraints and join tables all application constraints"
    task :constraints do
      DB.transaction do
        PlanningApp.all &:save # triggers after_save hook :)
      end
    end
  end
end
