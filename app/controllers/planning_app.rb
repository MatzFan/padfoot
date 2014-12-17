Padfoot::App.controllers :planning_app do

  before { redirect('/login') unless signed_in? }

  get :index, map: '/applications/index' do
    columns = [:app_ref, :app_category, :app_status]
    @titles = columns.map { |c| c.to_s.split('_').last.capitalize }
    @apps = Application.select_map(columns)
    render :index
  end

end