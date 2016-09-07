namespace :sq do
  namespace :apps do
    desc 'Uploads any new meeting docs to S3 and links planning apps to each;\
      returns a list of any planning applications that cannot be found/created'
    task docs: :environment do
      processor = AppDocProcessor.new
      # so correct FK's can be assigned to new docs
      DB.transaction { processor.create_meetings }
      broken_links = 0
      # uploads to S3 in the process :))
      DB.transaction { broken_links = processor.create_docs }
      apps_not_found = processor.create_doc_app_ref_links.uniq
      puts "Can't find:-\n#{apps_not_found.join("\n")}" if apps_not_found != []
      puts "#{broken_links} broken_links"
    end
  end
end
