describe TransactionLoader do
  T = Transaction
  ERR = TransactionLoader::LoadError
  DATA = [{ summary_details: 'UPRN should be 69205893',
            book_num: 1289,
            page_num: 910,
            page_suffix: nil,
            date: Date.new(2012, 01, 06),
            type: 'Realty - Sale' },
          [{ role: 'Vendor - Realty',
             surname: 'Gavey',
             forename: 'Timothy Christopher',
             maiden_name: '',
             ext_text: '' },
           { role: 'Vendor - Realty',
             surname: 'Hussey',
             forename: 'Catherine Nicola',
             maiden_name: '',
             ext_text: '' },
           { role: 'Vendor - Realty',
             surname: 'Gavey',
             forename: 'Catherine Nicola',
             maiden_name: 'Hussey',
             ext_text: '' },
           { role: 'Purchaser - Realty',
             surname: 'Howard-Houston',
             forename: 'Lilly Jane',
             maiden_name: '',
             ext_text: '' },
           { role: 'Purchaser - Realty',
             surname: 'Ash',
             forename: 'Lilly Jane',
             maiden_name: 'Howard-Houston',
             ext_text: '' }],
          [{ property_uprn: 69205893,
             parish: 'St. Clement',
             add_1: "St George's,",
             add_2: '2 Le Clos de Rocquebert,',
             add_3: '' }]
          ].freeze

  let(:trans) { T.new(book_num: 1289, page_num: 910) }
  let(:loader) { TransactionLoader.new(DATA) }

  before(:each) { trans.save }

  context '#new' do
    it 'should return an instance of the class' do
      expect(loader.class).to eq TransactionLoader
    end

    it "raises LoaderError if the transaction can't be found" do
      T.first.delete
      expect(-> { loader }).to raise_error TransactionLoader::LoadError
    end
  end

  context '#details' do
    it 'returns the details data element from a transaction data array' do
      expect(loader.instance_variable_get(:@details)).to eq DATA.first
    end
  end

  context '#parties' do
    it 'returns the parties data element from a transaction data array' do
      expect(loader.instance_variable_get(:@parties)).to eq DATA[1]
    end
  end

  context '#properties' do
    it 'returns the properties data element from a transaction data array' do
      expect(loader.instance_variable_get(:@properties)).to eq DATA[2]
    end
  end

  context '#trans' do
    it 'raises an error if the Transactions record is not found' do
      loader.instance_variable_set(:@bk, 9999)
      expect(-> { loader.trans }).to raise_error ERR
    end

    it 'returns a Transaction if the record is found' do
      expect(loader.trans.class).to eq Transaction
    end
  end

  context '#write_transaction(details data)' do
    it 'writes the summary details for the transaction, if any' do
      loader.write_transaction
      expect(T.first[:summary_details]).to eq 'UPRN should be 69205893'
    end
  end

  context '#write_parties(parties data)' do
    it 'adds a new Name record for each party which does not have one' do
      loader.write_parties
      expect(Name.count).to eq 5
    end

    it 'adds a NamesTransaction record for each party' do
      loader.write_parties
      expect(NamesTransaction.count).to eq 5
    end

    it 'writes no NamesTransaction data if there are no parties' do
      loader.instance_variable_set(:@parties, [])
      loader.write_parties
      expect(NamesTransaction.count).to eq 0
    end
  end

  context '#write_properties(properties data)' do
    it 'writes data for the transaction properties' do
      loader.write_properties
      expect(T.first.trans_props.count).to eq 1
    end

    it 'writes no Property data if there are no properties' do
      loader.instance_variable_set(:@properties, [])
      loader.write_properties
      expect(T.first.trans_props.count).to eq 0
    end
  end
end
