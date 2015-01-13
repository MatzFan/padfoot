describe 'PlanningApp Model' do

  let(:app) { create(:planning_app) }

  describe '#create' do
    it 'can be created' do
      expect(app).not_to be_nil
    end
  end

end
