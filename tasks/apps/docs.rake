namespace :sq do
  namespace :apps do
    desc "Uploads any new meeting docs to S3 and links planning apps to each; returns a list of any planning applications that cannot be found/created"
    task :docs do
      processor = AppDocProcessor.new
      DB.transaction { processor.create_meetings } # so correct FK's can be assigned to new docs
      DB.transaction { processor.create_docs } # uploads to S3 in the process :))
      apps_not_found = processor.create_doc_app_ref_links.uniq
      puts "Can't find:-\n#{apps_not_found.join("\n")}" if apps_not_found != []
    end
  end
end
