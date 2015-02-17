namespace :sq do
  namespace :apps do
    desc "Uploads any new planning application meeting documents to S3"
    task :docs do
      processor = AppDocProcessor.new
      DB.transaction { processor.create_meetings } # so correct FK's can be assigned to new docs
      DB.transaction { processor.create_docs } # uploads to S3 in the process :))
    end
  end
end
