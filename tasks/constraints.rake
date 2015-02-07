namespace :sq do
  namespace :apps do
    desc "Populate the constraints and join tables all application constraints"
    task :constraints do
      DB.transaction do
        PlanningApp.all &:add_constraints
      end
    end
  end
end
