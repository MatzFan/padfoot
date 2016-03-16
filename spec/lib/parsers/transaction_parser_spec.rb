describe TransactionParser do
  FIXTURE = '/Users/me/Documents/JPS/PRIDE/2012_1.txt'.freeze
  TRANSACTION = ["\n>Surname/ Corporate Name<\n>Howard-Houston<\n>Forename(s)<\n>Lilly Jane<\n>Extended Text<\n><\n>Maiden Name<\n><\n>Summary Details<\n>UPRN should be 69205893<\n>Book no/Suffix<\n>1289<\n>Folio/Suffix<\n>910<\n>Date Registered<\n>06/01/2012<\n>Register Type<\n>Table<\n>Parish<\n><\n>Number of Emargements<\n>0<\n>Doc Type<\n>Realty - Sale<\n>Number of Corrections<\n>0<\n>Party Code<\n>Purchaser - Realty<\n>Number of Rectifications<\n>0<\n", "\n>Vendor - Realty<\n>Gavey<\n>Timothy Christopher<\n><\n><\n>Vendor - Realty<\n>Hussey<\n>Catherine Nicola<\n><\n><\n>Vendor - Realty<\n>Gavey<\n>Catherine Nicola<\n>Hussey<\n><\n>Purchaser - Realty<\n>Howard-Houston<\n>Lilly Jane<\n><\n><\n>Purchaser - Realty<\n>Ash<\n>Lilly Jane<\n>Howard-Houston<\n><\n", "\n>69205893<\n>St. Clement<\n>St George's,<\n>2 Le Clos de Rocquebert,<\n><\n"].freeze
  "\n>Vendor - Realty<\n>Gavey<\n>Timothy Christopher<\n><\n><\n>Vendor - Realty<\n>Hussey<\n>Catherine Nicola<\n><\n><\n>Vendor - Realty<\n>Gavey<\n>Catherine Nicola<\n>Hussey<\n><\n>Purchaser - Realty<\n>Howard-Houston<\n>Lilly Jane<\n><\n><\n>Purchaser - Realty<\n>Ash<\n>Lilly Jane<\n>Howard-Houston<\n><\n"

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

  PARTIES = [PARTY1, PARTY2, PARTY3, PARTY4, PARTY5]

  PROPERTIES = [{ property_uprn: '69205893',
                  parish: 'St. Clement',
                  add_1: "St George's,",
                  add_2: '2 Le Clos de Rocquebert,',
                  add_3: ''}]

  let(:parser) { TransactionParser.new FIXTURE }

  context '#new' do
    it 'should return an instance of the class' do
      expect(parser.class).to eq TransactionParser
    end
  end

  context '#transactions' do
    it 'returns a collection whose size equals the number of transactions' do
      expect(parser.transactions.size).to eq 400
    end

    it 'returns a collection holding the text of each transaction' do
      expect(parser.transactions.first).to eq TRANSACTION
    end

    it 'returns a collection each of which has 3 elements' do
      expect(parser.transactions.all? { |e| e.size == 3 }).to eq true
    end
  end

  context '#parties(transaction)' do
    it 'returns a collection of party data hashes for the transaction' do
      expect(parser.parties(TRANSACTION)).to eq PARTIES
    end
  end

  context '#properties(transaction)' do
    it 'returns a collection of property data hashes for the transaction' do
      expect(parser.properties(TRANSACTION)).to eq PROPERTIES
    end
  end
end
