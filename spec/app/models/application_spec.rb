describe 'Application Model' do

  before(:each) do
    AppStatus.create(name: 'APPEAL')
    AppCategory.create(code: 'RW', name: 'RW')
    AppOfficer.create(name: 'Richard Greig')
    ParishAlias.create(name: 'St. Brelade')
  end

  let(:application) { create(:application) }

  describe 'creation' do
    it 'can be created' do
      expect(application).not_to be_nil
    end
  end

end
