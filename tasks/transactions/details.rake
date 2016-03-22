namespace :sq do
  desc 'Populates Transaction & related table data from JS-sourced data file'
  task :transactions, [:filepath] do |_, args|
    args.with_default(filepath: :environment)
    file = File.expand_path(args[:filepath], __FILE__)
    data = TransactionParser.new(file).data
    DB.transaction do
      # TransactionParser.new(file).data.each do |transaction_data|
      #   TransactionLoader.new(transaction_data).write
      # end
      TransactionLoader.new(data.first).write
    end
  end
end
