# helper for PlanningApp model
module PlanningAppHelper
  def table_apps(refs)
    apps = refs ? apps_ordered(refs) : all_apps_ordered
    apps = apps.select_map(PlanningApp::TABLE_COLS)
    apps.map! { |app| div_wrap_strings_in(app, classes_to_add) }
  end

  def classes_to_add # wrap txt in <div>s & add class to app_description for css
    PlanningApp::TABLE_COLS.map { |c| 'long-text' if c == :app_description }
  end

  def table_apps_json(refs) # expects string of comma-separated app_refs
    refs = refs.split(',').uniq if refs
    { columns: PlanningApp::TABLE_TITLES.map do |t|
      { title: t }
    end, app_data: table_apps(refs) }.to_json
  end

  def all_apps_ordered # all in descending :order
    PlanningApp.order(:order).reverse
  end

  def apps_ordered(refs) # selected in descending :order
    PlanningApp.where(app_ref: refs).order(:order).reverse
  end

  def div_wrap_strings_in(app, classes = [])
    app.each_with_index.map do |e, i|
      e.class == String ? div_wrap(e, classes[i]) : e
    end
  end

  def div_wrap(txt, class_to_add = nil)
    placeholder = class_to_add ? " class = '#{class_to_add}'" : ''
    "<div#{placeholder}>#{txt}</div>"
  end

  def trunc(t, n)
    t.split.size > 20 ? "#{t.split(/\s+/, n + 1)[0...n].join(' ')}..." : t
  end
end

Padfoot::App.helpers PlanningAppHelper
