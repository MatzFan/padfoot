Padfoot::App.controllers :planning_app do

  before { redirect('/login') unless signed_in? }

  get :index, map: '/applications/index', provides: [:html, :json] do
    columns = [:order, :valid_date, :app_ref, :app_code, :app_status,
      :app_address, :app_description, :app_applicant, :app_agent]
    @titles = columns.map { |c| c.to_s.split('_').last.capitalize }
    @apps = PlanningApp.order(:order).reverse.select_map(columns) # desc. order
    case content_type
    when :json
      # PlanningApp.to_json(only: columns, root: true)
      { columns: @titles.map { |t| { title: t } }, app_data: @apps }.to_json
    when :html
      msg =  ' Page loading, please be patient.'
      flash[:notice] ? flash[:notice] << msg : flash[:notice] = msg
      render :index
    else
    end
  end

  get :map, map: 'applications/map' do
    render :map
  end

end
