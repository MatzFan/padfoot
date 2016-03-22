describe Name do
  let(:name) { build(:name) }
  let(:entity_name) { build(:name, surname: 'ACME Ltd', forename: nil) }
  let(:person_name) { build(:name, surname: 'Doe', forename: 'John') }
  let(:married) { build(:name, surname: 'D', forename: 'J', maiden_name: 'B') }
  let(:maiden_name) { build(:name, surname: 'B', forename: 'J') }

  context '#create' do
    it 'can be created' do
      name.save
      expect(Name.count).to eq 1
    end

    context 'if forename is nil' do
      it 'creates a new Entity record' do
        entity_name.save
        expect(Entity.count).to eq 1
      end
    end

    context 'if forename is not nil' do
      context 'and maiden name does not exist in database' do
        it 'creates a new Person' do
          person_name.save
          expect(Person.count).to eq 1
        end
      end

      context 'and maiden name already exists in database' do
        it 'does NOT create a new Person record' do
          married.save
          maiden_name.save
          expect(Person.count).to eq 1
        end
      end
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
