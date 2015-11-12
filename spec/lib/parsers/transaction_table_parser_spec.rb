describe TransactionTableParser do

  file = "#{Padrino.root}/spec/fixtures/trans_table.html"
  let(:parser) { TransactionTableParser.new(file) }
  sequence = {nameSeq: 2016516, docSeq: 2034137}
  index_16 = {pa: nil, date: Date.new(2001, 01, 05),
           book_num: 1110, page_num: 270, e: nil, type: "Realty - Sale"}
  all = index_16.merge sequence

  context '#new' do
    it 'returns an instance of the class' do
      expect(parser.class).to eq(TransactionTableParser)
    end
  end

  context '#sequence_data' do
    it 'returns a an array of nameSeq and docSeq data hashes' do
      expect(parser.sequence_data[16]).to eq sequence
    end
  end

  context '#row_text' do
    it 'returns a 2D array of the 9-element table rows' do
      expect(parser.row_text.all? { |r| r.size == 9 }).to be_truthy
    end
  end

  context '#data' do
    it 'returns an array of table row data hashes' do
      expect(parser.data[16]).to eq index_16
    end
  end

  context '#all_data' do
    it 'returns an array of table row data hashes, including nameSeq & docSeq' do
      expect(parser.all_data[16]).to eq all
    end

    it 'will include :page_suffix if one exists - e.g. "339/A"' do
      expect(parser.all_data[1055][:page_num]).to eq 339
      expect(parser.all_data[1055][:page_suffix]).to eq 'A'
    end
  end

  context '#number' do
    it 'returns the number of data rows' do
      expect(parser.number).to eq 13650
    end
  end

end
