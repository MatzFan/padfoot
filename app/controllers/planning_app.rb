Padfoot::App.controllers :planning_app do

  before { redirect('/login') unless signed_in? }

  get :index, map: '/applications/index', provides: [:html, :json] do
    columns = [
      :order, :valid_date, :app_ref, :app_code, :app_status, :app_full_address,
      :app_description, :app_address_of_applicant, :app_agent, :app_officer]
    @titles = columns.map { |c| c.to_s.split('_').last.capitalize }
    @app_arr = PlanningApp.order(:order).reverse.select_map(columns) # 2D array
    # wrap txt in <div>s and add class to app_description for css formatting
    classes_to_add = columns.map { |c| 'long-text' if c == :app_description }
    @app_arr.map! { |app| div_wrap_strings_in(app, classes_to_add) }
    case content_type
    when :json
      { columns: @titles.map { |t| { title: t } }, app_data: @app_arr }.to_json
    when :html
      render :index
    else
    end
  end

  get :map, map: 'applications/map' do
    render :map
  end

end
