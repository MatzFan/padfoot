namespace :sq do
  namespace :apps do
    desc "Uploads any new planning application meeting documents to S3"
    task :docs do
      AppDosScraper.meet_data.each {|hash| Meeting.find_or_create(hash) }
      # new_docs = AppDocProcessor.new.new_doc_data

    end
  end
end
