namespace :sq do
  namespace :apps do
    desc "Update all applications of a given status-type (default: 'Pending')"
    task :changes, [:type] do |t, args|
      args.with_defaults(type: 'Pending')
      t = Time.now
      old_apps = PlanningApp.where(app_status: args.type).all
      new_data = AppDetailsScraper.new(old_apps.map(&:app_ref)).data
      # may contain {}'s if an app can no longer be scraped, so remove them and corresponding old_apps
      deleted = 0
      (0...new_data.size).each do |i|
        if new_data[i].empty?
          deleted += 1
          ref = old_apps[i].app_ref
          DB[:constraints_planning_apps].where(app_ref: ref).delete
          DB[:documents_planning_apps].where(app_ref: ref).delete
          puts PlanningApp[ref].delete # delete rows for 'dead' apps
          old_apps[i] = nil
        end
      end
      old_apps.compact!
      new_data.reject! &:empty?
      new_apps = new_data.map { |hash| PlanningApp.new(hash) }
      raise 'old_apps.count != new_apps.count' unless old_apps.count == new_apps.count
      new_apps.each &:valid? # needed to update derivative field values
      count = 0
      begin
        DB.transaction do
          old_apps.each_with_index do |app, i|
            if app != new_apps[i]
              count += 1
              app.update(new_data[i]) if (app.app_ref == new_apps[i][:app_ref])
              puts "#{count} applications updated, #{deleted} applications deleted in #{(Time.now - t).to_i/60} minutes"
            end
          end
        end
      rescue
        puts "ERROR in sq:apps:changes:\n\nnew_data[i] = #{new_data[i].inspect}\n\nnew_apps[i] = #{new_apps[i]}"
      end
    end
  end
end
