describe Property do

  let(:prop) { build(:property) }

  context '#new' do
    it 'can be created' do
      prop.save
      expect(Property.count).to eq(1)
    end

    it 'an instance will have :road field set' do
      prop.save
      expect(Property.first.road).not_to be_nil
    end

    it 'an instance will have :postcode field set' do
      prop.save
      expect(Property.first.postcode).not_to be_nil
    end

    it 'fields prop_lat and prop_long are set after saving, if x and y are present' do
      Property.new(uprn: 12345678, x: 47479, y: 63374).save
      expect([Property.first.prop_lat, Property.first.prop_long]).to eq([49.165375, -2.032449])
    end

    it 'fields prop_lat and prop_long are not set after saving, if x or y is missing' do
      Property.new(uprn: 12345678, prop_html: 'an address').save
      expect(Property.first.prop_lat && Property.first.prop_long).to be_nil
    end
  end

  context '#road' do
    it 'returns the associated RoadName' do
      prop.save
      expect(Property.first.road_name.class).to eq(RoadName)
    end
  end

  context '#parish' do
    it 'returns the associated Parish' do
      prop.save
      expect(Property.first.parish.class).to eq(Parish)
    end

    it 'will be nil if no parish was specified in object creation' do
      prop.parish = nil
      prop.save
      expect(Property.first.parish).to be_nil
    end
  end

  context '#postcode' do
    it 'returns the associated Postcode' do
      prop.save
      expect(Property.first.postcode.class).to eq(Postcode)
    end
  end

end
