Padfoot::App.controllers :planning_app do

  before { redirect('/login') unless signed_in? }

  get :index, map: '/applications/index', provides: [:html, :json] do
    columns = [
      :order, :valid_date, :app_ref, :app_code, :app_status, :app_full_address,
      :app_description, :app_applicant, :app_agent, :app_officer]
    @titles = columns.map { |c| c.to_s.split('_').last.capitalize }
    @apps = PlanningApp.order(:order).reverse.select_map(columns) # desc. order
    case content_type
    when :json
      { columns: @titles.map { |t| { title: t } }, app_data: @apps }.to_json
    when :html
      render :index
    else
    end
  end

  get :map, map: 'applications/map' do
    render :map
  end

end
