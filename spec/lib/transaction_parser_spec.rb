describe TransactionParser do

  uri = URI.join('file:///', "#{Padrino.root}/spec/fixtures/single_page_trans.html")
  let(:parser) { TransactionParser.new(uri) }

  context '#new' do
    it 'should return an instance of the class' do
      expect(parser.class).to eq(TransactionParser)
    end
  end

  context '#page' do
    it 'should return the Mechanize::Page for an html file' do
      expect(parser.page.class).to eq(Mechanize::Page)
    end
  end



end
