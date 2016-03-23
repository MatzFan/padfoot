namespace :sq do
  desc 'Populates Transaction & related table data from JS-sourced data file'
  task :transactions, [:filepath] do |_, args|
    args.with_default(filepath: :environment)
    file = File.expand_path(args[:filepath], __FILE__)
    TransactionParser.new(file).data.each do |transaction_data| # parser error?
      DB.transaction do
        TransactionLoader.new(transaction_data).write
      end
    end
  end
end
