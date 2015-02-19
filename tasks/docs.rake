namespace :sq do
  namespace :apps do
    desc "Uploads any new planning application meeting documents to S3 and links planning apps to each document"
    task :docs do
      processor = AppDocProcessor.new
      DB.transaction { processor.create_meetings } # so correct FK's can be assigned to new docs
      DB.transaction { processor.create_docs } # uploads to S3 in the process :))
      DB.transaction { pp processor.create_doc_app_ref_links }
    end
  end
end
