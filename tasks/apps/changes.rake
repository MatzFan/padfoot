namespace :sq do
  namespace :apps do
    desc "Update all applications of a given status-type (default: 'Pending')"
    task :changes, [:type] do |t, args|
      args.with_defaults(type: 'Pending')
      t = Time.now
      old_apps = PlanningApp.where(app_status: args.type).all
      new_data = AppDetailsScraper.new(old_apps.map(&:app_ref)).data
      # may contain {}'s if an app can no longer be scraped, so remove them and corresponding old_apps
      (0...new_data.size).each { |i| old_apps.delete_at(i) if new_data[i].empty? }
      new_data.reject!(&:empty?)
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
      puts "#{count} applications updated in #{(Time.now - t).to_i/60} minutes"
    end
  end
end
