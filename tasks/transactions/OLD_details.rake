# namespace :sq do
#   namespace :trans do
#     desc 'Populates parties and properties from a transaction details page'
#     task :details, [:filepath] => :environment do |t, args|
#       args.with_default(filepath: :environment)
#       file = File.expand_path(args[:filepath], __FILE__)
#       parser = TransactionParser.new(file)
#       book, page, sf = p.book_page_suffix
#       vars = { doc_num: nil, summary_details: nil }
#       vars.map { |k, _v| vars[k] = p.send k }
#       if book * page == 0
#         abort 'Book & page numbers are zero!'
#       else
#         t = Transaction.find(book_num: book, page_num: page, page_suffix: sf)
#         if t
#           parties = parser.parties_data
#           props = parser.properties_data
#           DB.transaction do
#             # t.update vars
#             # props.each do |p|
#             #   t.add_trans_prop TransProp.new(p)
#             # end unless props.empty?
#             unless parties.empty?
#               parties.each do |p| # NamesTransaction model represents parties
#                 name_hash = p.select { |k, _v| k.to_s[-4..-1] == 'name' }
#                 name = t.add_name Name.find_or_create name_hash
#                 nt = NamesTransaction[name_id: name.id, transaction_id: t.id]
#                 nt.update(role: p[:role], ext_text: p[:ext_text])
#               end
#             end
#           end
#         else
#           abort "No Transaction for book: #{book}, page: #{page}, suff: #{sf}"
#         end
#       end
#     end
#   end
# end
