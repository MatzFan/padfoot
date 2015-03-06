describe Address do

  let(:address) { build(:address) }

  context '#new' do
    it 'creates and instance of the class' do
      address.save
      expect(Address.count).to eq(1)
    end

    it 'an instance will have :road field set' do
      address.save
      expect(Address.first.road).not_to be_nil
    end

    it 'an instance will have :postcode field set' do
      address.save
      expect(Address.first.postcode).not_to be_nil
    end
  end

  context '#road' do
    it 'returns the associated RoadName' do
      address.save
      expect(Address.first.road_name.class).to eq(RoadName)
    end
  end

  context '#parish' do
    it 'returns the associated Parish' do
      address.save
      expect(Address.first.parish.class).to eq(Parish)
    end

    it 'will be nil if no parish was specified in object creation' do
      address.parish = nil
      address.save
      expect(Address.first.parish).to be_nil
    end
  end

  context '#postcode' do
    it 'returns the associated Postcode' do
      address.save
      expect(Address.first.postcode.class).to eq(Postcode)
    end
  end

end
