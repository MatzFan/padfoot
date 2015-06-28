describe TransactionParser do

  uri = URI.join('file:///', "#{Padrino.root}/spec/fixtures/single_page_trans.html")
  let(:parser) { TransactionParser.new(uri) }
  let(:single_property) { ["69117812", "St. Helier", "Almeda, 7 La Rue de Pod棚tre, "] }

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

  context '#tables' do
    it 'should return 8 tables for a page' do
      expect(parser.tables.count).to eq(8)
    end
  end

  context 'header data' do
    context '#header_table_rows' do
      it 'should have 7 elements' do
        expect(parser.header_table_rows.size).to eq(7)
      end
    end

    context '#doc_num' do
      it "should return 1" do
        expect(parser.doc_num).to eq(1)
      end
    end

    context '#doc_type' do
      it "should return 'Realty - Sale'" do
        expect(parser.doc_type).to eq('Realty - Sale')
      end
    end

  end

  context '#party_table_rows' do
    it 'should have 6 elements' do
      expect(parser.party_table_rows.size).to eq(6)
    end
  end

  context '#parties' do
    it "should return 5 parties" do
      expect(parser.parties.count).to eq(5)
    end
  end

  context '#property_table_rows' do
    it 'should have 2 elements' do
      expect(parser.property_table_rows.size).to eq(2)
    end
  end

  context '#properties' do
    it "returns a 2D 'property' array with a single element (one property)" do
      expect(parser.properties.count).to eq(1)
    end
  end

end
