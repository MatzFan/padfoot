describe Property do

  let(:prop) { build(:property) }
  let(:near_prop) { Property.create(uprn: 69127661, x: 33423.2999999998, y: 64858.1999999993) }
  let(:far_prop) { Property.create(uprn: 69003083, x: 42035.15699999966, y: 65219.985874999315) }

  context '#new' do
    it 'can be created' do
      prop.save
      expect(Property.count).to eq(1)
    end

    it 'an instance will have :type field set' do
      prop.save
      expect(Property.first.type).not_to be_nil
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

  context '#property_type' do
    it 'returns the associated PropertyType' do
      prop.save
      expect(Property.first.property_type.class).to eq(PropertyType)
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

  context '.within_x_meters_of' do
    it 'returns the properties within certain radius of a geographical point' do
      near_prop.save; far_prop.save
      expect(Property.within_x_meters_of(2000, 49.178609, -2.224561)).to eq([near_prop])
    end

    it 'returns no properties if radius is nil' do
      near_prop.save; far_prop.save
      expect(Property.within_x_meters_of(0, 49.178609, -2.224561)).to eq([])
    end

    it 'returns all properties if radius is large' do
      near_prop.save; far_prop.save
      expect(Property.within_x_meters_of(20000, 49.178609, -2.224561)).to eq([near_prop, far_prop])
    end
  end

end
