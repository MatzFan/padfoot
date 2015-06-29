describe TransactionTableParser do

  uri = URI.join('file:///', "#{Padrino.root}/spec/fixtures/trans_table.html")
  let(:parser) { TransactionTableParser.new(uri) }
  first = ["27/11/2012", "1304", "471", "Will Registered"]

  context '#new' do
    it 'should return an instance of the class' do
      expect(parser.class).to eq(TransactionTableParser)
    end
  end

  context '#row_data' do
    it 'should return a 2D array of the 8-element table rows' do
      expect(parser.row_data.all? { |r| r.size == 8 }).to be_truthy
    end
  end

  context '#data' do
    it 'should return the table rows' do
      expect(parser.data.first).to eq(first)
    end
  end

end
