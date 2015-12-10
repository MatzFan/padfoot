describe Person do

  let(:person_no_maiden_name) { Person.new(forename: 'Joan', surname: 'Doe') }
  let(:person_with_maiden_name) { Person.new(forename: 'Joan', surname: 'Doe', maiden_name: 'Bloggs') }

  context '#create' do
    it 'can be created' do
      person_no_maiden_name.save
      expect(Person.count).to eq 1
    end

    context 'with a maiden name' do
      it 'creates a related Name record, if it does not exist' do
        person_with_maiden_name.save
        expect(Name.count).to eq 1
      end
    end
  end

end
