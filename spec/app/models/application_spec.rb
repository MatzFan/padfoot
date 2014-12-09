describe 'Application Model' do

  let(:application) { Application.create({ app_ref: 'P/2012/0219',
                                   app_status: 'Pending',
                                   app_category: 'P',
                                   app_officer: 'Joe Bloggs',
                                   app_parish: 'St Helier',
                                   app_agent: 'Riva Architects'
                                   }) }

  it 'can be created' do
    expect(application).not_to be_nil
  end

end
