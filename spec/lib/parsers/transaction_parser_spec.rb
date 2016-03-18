describe TransactionParser do
  FIXTURE = '/Users/me/Documents/JPS/PRIDE/2012_1.txt'.freeze
  TRANS = ["\n>Surname/ Corporate Name<\n>Howard-Houston<\n>Forename(s)<\n>Lilly Jane<\n>Extended Text<\n><\n>Maiden Name<\n><\n>Summary Details<\n>UPRN should be 69205893<\n>Book no/Suffix<\n>1289<\n>Folio/Suffix<\n>910<\n>Date Registered<\n>06/01/2012<\n>Register Type<\n>Table<\n>Parish<\n><\n>Number of Emargements<\n>0<\n>Doc Type<\n>Realty - Sale<\n>Number of Corrections<\n>0<\n>Party Code<\n>Purchaser - Realty<\n>Number of Rectifications<\n>0<\n", "\n>Vendor - Realty<\n>Gavey<\n>Timothy Christopher<\n><\n><\n>Vendor - Realty<\n>Hussey<\n>Catherine Nicola<\n><\n><\n>Vendor - Realty<\n>Gavey<\n>Catherine Nicola<\n>Hussey<\n><\n>Purchaser - Realty<\n>Howard-Houston<\n>Lilly Jane<\n><\n><\n>Purchaser - Realty<\n>Ash<\n>Lilly Jane<\n>Howard-Houston<\n><\n", "\n>69205893<\n>St. Clement<\n>St George's,<\n>2 Le Clos de Rocquebert,<\n><\n"].freeze
  TRANS_ODD_PROP = ["\n>Surname/ Corporate Name<\n>Hall<\n>Forename(s)<\n>Rose Anne Avril<\n>Extended Text<\n><\n>Maiden Name<\n><\n>Summary Details<\n><\n>Book no/Suffix<\n>1290<\n>Folio/Suffix<\n>983<\n>Date Registered<\n>03/02/2012<\n>Register Type<\n>Table<\n>Parish<\n><\n>Number of Emargements<\n>0<\n>Doc Type<\n>Realty - Sale<\n>Number of Corrections<\n>0<\n>Party Code<\n>Purchaser - Realty<\n>Number of Rectifications<\n>0<\n", "\n>Vendor - Realty<\n>Black Labradors Limited<\n><\n><\n><\n>Purchaser - Realty<\n>Hall<\n>Rose Anne Avril<\n><\n><\n>Purchaser - Realty<\n>Mitchell<\n>Rose Anne Avril<\n>Hall<\n><\n", "\n>69119482<\n>St. Brelade<\n>Holly Cottage,<\n>La Rue du Crocquet,<\n><\n>St. Brelade<\n>Parking Space adjoining Blue Ridge,<\n>La Rue du Crocquet,<\n><\n"].freeze
  DETAILS_TEXT = TRANS[0]
  PARTIES_TEXT = TRANS[1]
  PROPERTIES_TEXT = TRANS[2]
  BAD_PROPERTY_TEXT = "\n>69123456<\n>St. Brelade<\n>add1,<\n>add2,<\n><\n>NOT A PARISH<\n>a1,<\n>a2,<\n><\n".freeze
  ODD_PROPERTIES_TEXT = TRANS_ODD_PROP[2]
  ERR = TransactionParser::ParserError

  DETAILS = { summary_details: 'UPRN should be 69205893',
              book_num: '1289',
              page_num: '910',
              page_suffix: '',
              date: '06/01/2012',
              type: 'Realty - Sale' }.freeze

  PARTY1 = { role: 'Vendor - Realty',
             surname: 'Gavey',
             forename: 'Timothy Christopher',
             maiden_name: '',
             ext_text: '' }.freeze

  PARTY2 = { role: 'Vendor - Realty',
             surname: 'Hussey',
             forename: 'Catherine Nicola',
             maiden_name: '',
             ext_text: '' }.freeze

  PARTY3 = { role: 'Vendor - Realty',
             surname: 'Gavey',
             forename: 'Catherine Nicola',
             maiden_name: 'Hussey',
             ext_text: '' }.freeze

  PARTY4 = { role: 'Purchaser - Realty',
             surname: 'Howard-Houston',
             forename: 'Lilly Jane',
             maiden_name: '',
             ext_text: '' }.freeze

  PARTY5 = { role: 'Purchaser - Realty',
             surname: 'Ash',
             forename: 'Lilly Jane',
             maiden_name: 'Howard-Houston',
             ext_text: '' }.freeze

  PARTIES = [PARTY1, PARTY2, PARTY3, PARTY4, PARTY5].freeze

  PROPS = [{ property_uprn: '69205893',
             parish: 'St. Clement',
             add_1: "St George's,",
             add_2: '2 Le Clos de Rocquebert,',
             add_3: '' }].freeze

  ODD_PROPS = [{ property_uprn: '69119482',
                 parish: 'St. Brelade',
                 add_1: 'Holly Cottage,',
                 add_2: 'La Rue du Crocquet,',
                 add_3: '' },
                { property_uprn: '',
                  parish: 'St. Brelade',
                  add_1: 'Parking Space adjoining Blue Ridge,',
                  add_2: 'La Rue du Crocquet,',
                  add_3: '' }].freeze

  let(:p) { TransactionParser.new FIXTURE }

  context '#new' do
    it 'should return an instance of the class' do
      expect(p.class).to eq TransactionParser
    end
  end

  context '#transactions' do
    it 'returns a collection whose size equals the number of transactions' do
      expect(p.transactions.size).to eq 400
    end

    it 'returns a collection holding the text of each transaction' do
      expect(p.transactions.first).to eq TRANS
    end

    it 'returns a collection each of which has 3 elements' do
      expect(p.transactions.all? { |e| e.size == 3 }).to eq true
    end
  end

  context '#details(details_text)' do
    it 'returns a collection of detail data hashes from details text' do
      expect(p.details(DETAILS_TEXT)).to eq DETAILS
    end
  end

  context '#split_suffix(page_num_string)' do
    it 'returns a 2-element array: page number and suffix' do
      expect(p.split_suffix('123/A')).to eq %w(123 A)
    end

    it 'returns page number and "", if there is no suffix' do
      expect(p.split_suffix('123')).to eq ['123', '']
    end
  end

  context '#parties(transaction)' do
    it 'returns a collection of party data hashes for the transaction' do
      expect(p.parties(PARTIES_TEXT)).to eq PARTIES
    end
  end

  context '#properties(transaction)' do
    it 'returns a collection of property data hashes for the transaction' do
      expect(p.properties(PROPERTIES_TEXT)).to eq PROPS
    end

    context 'where a UPRN field is missing in property text' do
      it 'inserts an empty UPRN field' do
        expect(p.properties(ODD_PROPERTIES_TEXT)).to eq ODD_PROPS
      end

      it 'raises ParserError if the first field is not a Parish name' do
        expect(-> { p.properties(BAD_PROPERTY_TEXT) }).to raise_error ERR
      end
    end
  end

  context '#transaction_data(transaction)' do
    it 'returns a 2D collection of all data hashes for a given transaction' do
      expect(p.transaction_data(TRANS)).to eq [DETAILS, PARTIES, PROPS]
    end

    it 'properties part may be empty (no properties specified)' do
      parser = p
      trans = parser.instance_variable_get(:@transactions)[378]
      expect(parser.transaction_data(trans).last).to be_empty
    end
  end

  context '#data' do
    it 'returns a collection of all transaction data hashes' do
      expect(p.data.size).to eq 400
    end

    it 'returns a collection whose 1st elements are a hash (details)' do
      expect(p.data.all? { |e| e[0].class == Hash }).to eq true
    end

    it 'returns a collection whose 2nd elements are collections of hashes' do
      expect(p.data.all? { |e| e[1].all? { |f| f.class == Hash } }).to eq true
    end

    it 'returns a collection whose 3rd elements are collections of hashes' do
      expect(p.data.all? { |e| e[2].all? { |f| f.class == Hash } }).to eq true
    end
  end
end
