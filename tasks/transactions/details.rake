namespace :sq do
  namespace :trans do
    desc "Populates parties and properties from a transaction details page"
    task :details, [:filepath] do |t, args|
      args.with_default(:filepath => :environment)
      file = File.expand_path(args[:filepath], __FILE__)
      p = TransactionParser.new(file)
      book, page, sf = p.book_page_suffix
      vars = {doc_num: nil, summary_details: nil}
      vars.map { |k,v| vars[k] = p.send k}
      if book * page == 0
        exit 'Book & page numbers are zero!'
      else
        t = Transaction.find(book_num: book, page_num: page, page_suffix: sf)
        if t
          parts, prps = p.parties_data, p.properties_data
          DB.transaction do
            t.update vars
            parts.each { |p| t.add_party Party.new(p) } if !parts.empty?
            prps.each { |p| t.add_trans_prop TransProp.new(p) } if !prps.empty?
          end
        else
          exit "No Transaction for book: #{book}, page: #{page}, suffix: #{sf}"
        end
      end
    end
  end
end
