Padfoot::App.controllers :planning_app do

  before { redirect('/login') unless signed_in? }

  get :index, map: '/applications/index' do
    columns = [:order, :app_ref, :app_code, :app_status, :app_address, :app_description, :app_applicant, :app_agent]
    @titles = columns.map { |c| c.to_s.split('_').last.capitalize }
    @apps = PlanningApp.select_map(columns)
    render :index
  end

  get :map, map: 'applications/map' do
    render :map
  end

end
