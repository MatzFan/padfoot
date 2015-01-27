describe PlanningApp do

  let(:app) { create(:planning_app) }

  context '#create' do
    it 'can be created' do
      expect(app).not_to be_nil
    end
  end

  context '.latest_app_num_for' do
    it 'returns the latest app number for the given year' do
      create(:planning_app)
      app_year, app_num = app.app_year, app.app_number #create another record with incremented ref (& number)
      expect(PlanningApp.latest_app_num_for(app_year)).to eq(app_num)
    end
  end

end
