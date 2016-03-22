describe Person do
  let(:person) { Person.new(forename: 'Joan', surname: 'Doe') }

  context '#create' do
    it 'is created ' do
      person.save
      expect(Person.count).to eq 1
    end
  end
end
