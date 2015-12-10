describe Name do

  let(:name) { build(:name) }
  let(:entity_name) { build(:name, surname: 'ACME Ltd', forename: nil) }
  let(:person_name) { build(:name, surname: 'Doe', forename: 'John') }
  let(:married_name) { build(:name, surname: 'Doe', forename: 'Jane', maiden_name: 'Bloggs') }
  let(:maiden_name) { build(:name, surname: 'Bloggs', forename: 'Jane') }

  context '#create' do
    it 'can be created' do
      name.save
      expect(Name.count).to eq 1
    end

    it 'creates a new Entity record if self.forename is nil' do
      entity_name.save
      expect(Entity.count).to eq 1
    end

    it 'creates a new Person record if forename is not nil and maiden name does not exist' do
      person_name.save
      expect(Person.count).to eq 1
    end

    it 'does NOT create a new Person record if forename is not nil and maiden name DOES exist' do
      married_name.save
      maiden_name.save
      expect(Person.count).to eq 1
    end
  end

  context '#entity' do
    it 'returns nil if there is no related Entity record' do
      person_name.save
      expect(Name.first.entity).to eq nil
    end

    it 'returns the related Entity record, if there is one' do
      entity_name.save
      expect(Name.first.entity.class).to eq Entity
    end
  end

  context '#person' do
    it 'returns nil if there is no related Person record' do
      entity_name.save
      expect(Name.first.person).to eq nil
    end

    it 'returns the related Person record, if there is one' do
      person_name.save
      expect(Name.first.person.class).to eq Person
    end
  end

end
