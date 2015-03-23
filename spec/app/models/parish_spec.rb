describe Parish do

  let(:parish) { Parish[5] } # St. John
  let(:st_john_property) { Property.create(uprn: 69128076, x: 41360.0999999996, y: 72728.1999999993) }
  let(:st_clement_property) { Property.create(uprn: 69110131, x: 43835.5999999996, y: 63568.1999999993) }

  context '#new' do
    it 'can be created from an existing DB entry' do
      expect(parish.name).to eq('St. John')
    end
  end

  context '#contains?' do
    it 'returns true if an object is within it' do
      expect(parish.contains? st_john_property).to eq(true)
    end

    it 'returns false if an object is not within it' do
      expect(parish.contains? st_clement_property).to eq(false)
    end
  end

end
