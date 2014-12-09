describe 'Application Model' do

  before(:each) do
    AppStatus.create(name: 'APPEAL')
    AppCategory.create(code: 'RW', name: 'RW')
    AppOfficer.create(name: 'Richard Greig')
    ParishAlias.create(name: 'St. Brelade')
  end

  let(:pk) { {app_ref: 'RW/2014/0548'} }
  let(:fk) { {app_status: 'APPEAL', app_category: 'RW', app_officer: 'Richard Greig',
             app_parish: 'St. Brelade'}
           }

  let(:app_no_fks) { Application.create(pk) }
  let(:application) { Application.create(pk.merge(fk)) }

  describe "without fk's" do
    it 'can be created' do
      expect(app_no_fks).not_to be_nil
    end
  end

  describe "with fk's" do
    it 'can be created' do
      expect(application).not_to be_nil
    end
  end

end
