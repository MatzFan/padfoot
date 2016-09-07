require_relative '../../lib/parsers/transaction_parser'
require_relative '../../lib/loaders/transaction_loader'

namespace :sq do
  namespace :trans do
    desc 'Populates Transaction & related table data from JS-sourced data file'
    task :load, [:filepath] => :environment do |_, args|
      args.with_default(filepath: :environment)
      file = File.expand_path(args[:filepath], __FILE__)
      TransactionParser.new(file).data.each do |transaction_data| # parsererror?
        DB.transaction do
          TransactionLoader.new(transaction_data).write
        end
      end
    end
  end
end
