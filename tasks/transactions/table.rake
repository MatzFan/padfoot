namespace :sq do
  namespace :trans do
    desc "Populates transactions table from PRIDE query tabular results"
    task :table, [:filepath] do |t, args|
      args.with_default(:filepath => :environment)
      file = File.expand_path(args[:filepath], __FILE__)
      data_array = TransactionTableParser.new(file).all_data
      DB.transaction do
        data_array.each { |hash| Transaction.create hash }
      end
    end
  end
end
