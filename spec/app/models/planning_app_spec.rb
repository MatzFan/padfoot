describe PlanningApp do

  let(:app) { create(:planning_app) }

  context '.latest_app_num_for' do
    it 'returns the latest app number for the given year' do
      create(:planning_app)
      app_year, app_num = app.app_year, app.app_number #create another record with incremented ref (& number)
      expect(PlanningApp.latest_app_num_for(app_year)).to eq(app_num)
    end
  end

  context '#create' do
    it 'an instance of the class can be created' do
      expect(app).not_to be_nil
    end

    it 'duplicate app numbers and years are permitted - eg: P/1995/0263 & D/1995/0263' do
      expect(->{ PlanningApp.create(app_ref: 'P/1995/0263'); PlanningApp.create(app_ref: 'D/1995/0263')}).not_to raise_error
    end
  end

  context '#all_constraints' do
    it 'returns a sorted array of the constraints in the app_constraints field' do
      expect(app.all_constraints).to eq(app.app_constraints.split(', ').sort)
    end
  end

end
