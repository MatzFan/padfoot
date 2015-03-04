describe Location do

  let(:loc) { build(:location) }

  context '#new' do
    it 'can be created' do
      loc.save
      expect(Location.count).to eq(1)
    end

    it 'fields loc_lat and loc-long are set after saving' do
      loc.save
      expect(Location.first.loc_lat && Location.first.loc_long).not_to be_nil
    end
  end



end
