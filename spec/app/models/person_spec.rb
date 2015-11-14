describe Person do

  let(:person_name) { Name.new(forename: 'Joan', surname: 'Doe', maiden_name: 'Test') }
  let(:person) { Person.new(forename: 'Joan', surname: 'Doe', maiden_name: 'Test') }

  context '#create' do
    it 'can be created' do
      person.save
      expect(Person.count).to eq 1
    end

    # it 'will be created when a new Name record is created, if the name is new' do
    #   person_name.save
    #   expect(Person.count).to eq 1
    # end
  end

end
