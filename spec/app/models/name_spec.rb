describe Name do
  P = Person
  NAMES = [:forename, :surname, :maiden_name]
  let(:name) { build(:name) }
  let(:entity_name) { build(:name, surname: 'ACME Ltd', forename: nil) }
  let(:person_name) { build(:name, surname: 'Doe', forename: 'John') }
  let(:married) do
    build(:name, surname: 'Bloggs', forename: 'Jane', maiden_name: 'Doe')
  end
  let(:maiden) do
    build(:name, surname: 'Doe', forename: 'Jane')
  end

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
      context 'and Person does not exist in database' do
        it 'creates a new Person' do
          person_name.save
          expect(Person.count).to eq 1
        end
      end

      context 'and maiden name already exists in database' do
        it 'does NOT create a new Person record' do
          married.save
          maiden.save
          expect(Person.count).to eq 1
        end

        it 'the record has correct forename, surname and maiden name' do
          married.save
          maiden.save
          expect([P.first.forename, P.first.surname]).to eq %w(Jane Doe)
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
