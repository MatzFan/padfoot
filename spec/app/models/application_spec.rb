describe 'Application Model' do

  before(:each) do
    AppStatus.create(name: 'Pending')
    AppCategory.create(code: 'P', name: 'Planning')
    AppOfficer.create(name: 'A Other')
    AgentAlias.create(name: 'Riva Architects')
    ParishAlias.create(name: 'St Helier')
  end

  let(:pk) { {app_ref: 'P/2012/0219'} }
  let(:fk) { {app_status: 'Pending', app_category: 'P', app_officer: 'A Other',
             app_parish: 'St Helier', app_agent: 'Riva Architects'}
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
