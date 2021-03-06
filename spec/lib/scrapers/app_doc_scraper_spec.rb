#  describe AppDocScraper do

#   let(:doc_types) { %w(Agenda Minutes) }
#   let(:tbl_types) { %w(PAC PAC PAP MM) }
#   let(:meeting_types) { %w(PAP MM PAC) }

#   let(:scraper) { AppDocScraper.new }
#   titles = ["2015 Upcoming Planning Applications Committee meetings",
#             "2015 Planning Applications Committee meetings",
#             "2014 & 2015 Planning Applications Panel meetings",
#             "2015 Ministerial meetings"]

#   context '#page' do
#     it "should return the agendas/minutes page source" do
#       expect(scraper.page.title).to include('Agendas and minutes')
#     end
#   end

#   context '#verify_structure' do
#     it "raises an error if number of tables doesn't match the number of table titles" do
#       allow(scraper).to receive(:tables) { [] } # zero length array
#       expect(->{ scraper.verify_structure }).to raise_error
#     end

#     it "raises an error if number of links does not equal number of doc_types" do
#       allow(scraper).to receive(:links) { [] } # zero length array
#       expect(->{ scraper.verify_structure }).to raise_error
#     end

#     it "raises an error if number of links does not equal number of file names" do
#       allow(scraper).to receive(:file_names) { [] } # zero length array
#       expect(->{ scraper.verify_structure }).to raise_error
#     end
#   end

#   context '#table_titles' do
#     it 'returns an array of the table titles for each set of meetings' do
#       expect(scraper.table_titles).to eq(titles)
#     end
#   end

#   context '#table_years' do
#     it 'returns an array of the year extracted from the table titles, if any' do
#       expect(scraper.table_years).to eq([2015,2015,nil,2015])
#     end
#   end

#   context '#table_agenda_columns' do
#     it 'returns an array of the column number entitled "Agenda" in each table' do
#       expect(scraper.table_agenda_columns).to eq([2,1,1,1])
#     end
#   end

#   context '#table_minutes_columns' do
#     it 'returns an array of the column number entitled "Minutes" in each table, if any' do
#       expect(scraper.table_minutes_columns).to eq([nil,2,2,2])
#     end
#   end

#   context '#table_types' do
#     it 'returns an array of the table meeting type, if any' do
#       expect(scraper.table_types).to eq(tbl_types)
#     end
#   end

#   context '#links' do
#     it 'returns an array of pdf links from each table' do
#       expect(scraper.links.all? { |link| link[-4..-1] == '.pdf'}).to be_truthy
#     end
#   end

#   context '#table_link_columns' do
#     it 'returns a 2D array of the column number each table link if found in, by table' do
#       expect(scraper.table_link_columns.flatten.all? { |c| [1,2,3].any? { |n| c == n } }).to be_truthy
#     end
#   end

#   context '#meet_types' do
#     it 'should return an array only of correct meeting types' do
#       expect(scraper.meet_types.all? { |type| meeting_types.any? { |m| type == m } }).to be_truthy
#     end
#   end

#   context '#table_link_names' do
#     it 'should return a 2D array document link-names by table' do
#       expect(scraper.table_link_names.all? do |t|
#         t.all? { |s| s.include?('Download ') }
#       end).to be_truthy
#     end
#   end

#   context '#doc_part_numbers' do
#     it 'returns an array of "underscore<part number>" for each document, if any' do
#       expect(scraper.doc_part_numbers.compact.all? { |e| e.split('_').last.to_i > 0 }).to be_truthy
#     end
#   end

#   context '#doc_dates' do
#     it 'should return an array only of valid dates' do
#       expect(scraper.doc_dates.all? { |e| e.kind_of?(Date) }).to be_truthy
#     end
#   end

#   context '#year_from_uri' do
#     it 'should return a year from a uri string' do
#       scraper.instance_variable_set(:@table_links, [['http://www.gov.je/SiteCollectionDocuments/Planning%20and%20building/M%20MM%202014-08-15.pdf']])
#       expect(scraper.year_from_uri(0,0)).to eq(2014)
#     end
#   end

#   context '#doc_types' do
#     it 'should return an array only of correct document types' do
#       expect(scraper.doc_types.all? { |type| doc_types.any? { |m| type == m } }).to be_truthy
#     end
#   end

#   context '#file_names' do
#     it 'returns an array of strings of format: yymmdd_[PAP/MM/PAC]_[A/M]' do
#       expect(scraper.file_names.all? { |s| s =~ /^\d{6}_(PAP|MM|PAC)_(A|M)(_\d)?$/ }).to be_truthy
#     end
#   end

#   context '#meet_data' do
#     it 'returns an array of meetings data hashes: {type: xxx, date: xxx}' do
#       expect(scraper.meet_data.all? do |h|
#         meeting_types.any? { |m| h[:type] == m } && h[:date].kind_of?(Date)
#       end).to be_truthy
#     end
#   end

#   context '#doc_data' do
#     it 'returns an array of documents data hashes: {type: xxx, name: xxx, url: xxx.pdf}' do
#       expect(scraper.doc_data.all? do |h|
#         doc_types.any? { |m| h[:type] == m } && h[:name].kind_of?(String) && h[:link][-4..-1] == '.pdf'
#       end).to be_truthy
#     end
#   end

#   context '#data_pairs' do
#     it 'returns a 2D array of [document hash, meeting hash] pairs' do
#       expect(scraper.data_pairs.all? do |arr|
#         arr[0].class == Hash && arr[1].class == Hash
#       end).to be_truthy
#     end
#   end

# end
