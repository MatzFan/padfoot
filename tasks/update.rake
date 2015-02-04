namespace :sq do
  namespace :apps do
    desc "Update all applicaitons with 'pending' status"
    task :update do
      apps = PlanningApp.where(app_status: 'Pending')
      count = 0
      apps.all[60..64].each do |app|
        new_app = PlanningApp.new(AppDetailsScraper.new(app.app_ref).data_hash)
        if new_app.valid? && if app != new_app # valid? populates derivative fields
            db_hash, new_hash = app.to_hash, new_app.to_hash
            diffs = Hash[*(new_hash.to_a - db_hash.to_a).flatten]
            diffs.each { |k,v| app.send("#{k}=", v) }
            app.save
            count += 1
          end
        end
      end
      logger.info "#{count} applications updated"
    end
  end
end
