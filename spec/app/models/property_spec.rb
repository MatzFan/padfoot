describe Property do

  let(:loc) { build(:property) }

  context '#new' do
    it 'can be created' do
      loc.save
      expect(Property.count).to eq(1)
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

end
