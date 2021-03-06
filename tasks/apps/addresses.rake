namespace :sq do
  namespace :apps do
    desc "Update all 'app_full_address' and 'app_address_of_applicant' fields"
    task addresses: :environment do
      DB.transaction do
        PlanningApp.all.each do |app|
          app.app_full_address = app.build_address
          app.app_address_of_applicant = app.build_address_of_applicant
          app.save
        end
      end
    end
  end
end
