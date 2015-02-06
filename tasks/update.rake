namespace :sq do
  namespace :apps do
    desc "Update all applicaitons with 'pending' status"
    task :update do
      old_apps = PlanningApp.where(app_status: 'Pending')
      new_data = AppDetailsScraper.new(old_apps.select_map(:app_ref)).data
      new_apps = new_data.map { |hash| PlanningApp.new(hash) }
      new_apps.each &:valid? # needed to update derivative field values
      count = 0
      DB.transaction do
        old_apps.each_with_index do |app, i|
          if app != new_apps[i]
            count += 1
            app.update(new_data[i]) if (app.app_ref == new_apps[i][:app_ref])
          end
        end
      end
      puts "#{count} applications updated"
    end
  end
end
