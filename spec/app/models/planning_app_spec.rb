describe PlanningApp do

  let(:app) { create(:planning_app) }
  let(:near_app) { PlanningApp.create(app_ref: 'P/2015/1234', latitude: 49.178731, longitude: -2.225203) }
  let(:far_app) { PlanningApp.create(app_ref: 'A/2014/2345', latitude: 49.182016, longitude: -2.107085) }
  let(:line_string) { "'LINESTRING(38818.777146 71930.481571, 38431.026905 71020.6382, 39718.715094 71120.14873, 38818.777146 71930.481571)'"}

  context '.line_string' do
    it 'returns text represenation of a PostGIS linestring' do
      lats = [49.2423570821659, 49.23417522262926, 49.23507193090019, 49.2423570821659]
      longs = [-2.1512220001220683, -2.156543502807615, -2.1388623809814433, -2.1512220001220683]
      expect(PlanningApp.line_string(lats, longs)).to eq(line_string)
    end
  end

  context '.nearest_to' do
    it 'returns a single PlanningApp object' do
      near_app.save; far_app.save
      expect(PlanningApp.nearest_to(49.178609, -2.224561).class).to eq(PlanningApp)
    end

    it 'returns the planning application nearest to a geographical point' do
      near_app.save; far_app.save
      expect(PlanningApp.nearest_to(49.178609, -2.224561).app_ref).to eq('P/2015/1234')
    end
  end

  context '.within_circle' do
    it 'returns an array of app objects' do
      near_app.save; far_app.save
      expect(PlanningApp.within_circle(49.178609, -2.224561, 20000).map &:class).to eq([PlanningApp, PlanningApp])
    end

    it 'returns the applications within the circle' do
      near_app.save; far_app.save
      expect(PlanningApp.within_circle(49.178609, -2.224561, 20000).map &:app_ref).to eq(['P/2015/1234', 'A/2014/2345'])
    end

    it "doesn't return applications outside the circle" do
      near_app.save; far_app.save
      expect(PlanningApp.within_circle(49.178609, -2.224561, 2000).map &:app_ref).to eq(['P/2015/1234'])
    end

    it 'returns an empty array if no applications are in the circle' do
      near_app.save; far_app.save
      expect(PlanningApp.within_circle(49.178609, -2.224561, 2).map &:app_ref).to eq([])
    end
  end

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

  context '#set_geom' do
    it 'sets to geom field to a SRID 3109 x, y geometry point from lat, long' do
      app = PlanningApp.new(app_ref: 'A/2013/1234', latitude: 49.182016, longitude: -2.107085)
      app.valid?
      expect(app.geom).to eq(DB["SELECT ST_SetSRID(ST_Point(42035.137027, 65219.966892),3109)::geometry"])
    end
  end

end
