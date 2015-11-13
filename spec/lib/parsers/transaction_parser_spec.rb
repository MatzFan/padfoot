describe TransactionParser do

  file = "#{Padrino.root}/spec/fixtures/trans_details.html"
  let(:parser) { TransactionParser.new(file) }
  let(:party1_hash) { {role: 'Vendor - Realty', surname: 'BROWN', maiden_name: nil,
                      forename: 'Phillip Andrew', ext_text: 'or Philip Andrew'} }
  let(:party3_hash) { {role: 'Vendor - Realty', surname: 'Brown', maiden_name: 'Sowden',
                      forename: 'Nicolle Stephanie Cubitt', ext_text: nil} }
  let(:property_hash) { {property_uprn: '69117812', parish: 'St. Helier',
                         address: 'Almeda, 7 La Rue de Podêtre,'} }

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
    context '#header_trs' do
      it 'should have 7 elements' do
        expect(parser.header_trs.size).to eq(7)
      end
    end

    context '#extended_text' do
      it "returns the extended text field" do
        expect(parser.extended_text).to be_nil
      end
    end

    context '#summary_details' do
      it "returns the summary details field" do
        expect(parser.summary_details).to be_nil
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

    context '#book_page_suffix' do
      it "returns an 3-element array of book and page integers and nil if there is no suffix" do
        expect(parser.book_page_suffix).to eq([1271, 699, nil])
      end

      it "returns an 3-element array of book and page integers and the page_num suffix if there is one" do
        p = parser
        allow(p).to receive(:book_page_text) { ["                1271", "                699/A"] }
        expect(p.book_page_suffix).to eq([1271, 699, 'A'])
      end
    end

    context '#reg_date' do
      it "returns the registration date" do
        expect(parser.reg_date.to_s).to eq('2011-01-07')
      end
    end

  end

  context 'party data' do
    context '#party_trs' do
      it 'should have 6 elements' do
        expect(parser.party_trs.size).to eq(6)
      end
    end

    context '#parties' do
      it "should return 5 parties" do
        expect(parser.parties.count).to eq(5)
      end
    end

    context '#parties_data' do
      it "returns an array of party data hashes" do
        expect(parser.parties_data[0]).to eq(party1_hash)
      end

      it "returns an array of party data hashes, which includes maiden name" do
        expect(parser.parties_data[2]).to eq(party3_hash)
      end
    end

  end

  context '#prop_trs' do
    it 'should have 2 elements' do
      expect(parser.prop_trs.size).to eq(2)
    end
  end

  context '#properties' do
    it "returns a 2D 'property' array with a single element (one property)" do
      expect(parser.properties.count).to eq(1)
    end
  end

  context '#properties_data' do
    it "returns an array of property data hashes" do
      expect(parser.properties_data[0]).to eq(property_hash)
    end
  end

end
