Padfoot::App.controllers :planning_app do

  get :index, map: '/index' do
    @titles = [:app_ref, :app_category, :app_status]
    @apps = Application.select_map(@titles)
    render :index
  end

end
