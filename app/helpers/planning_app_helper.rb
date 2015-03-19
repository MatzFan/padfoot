module PlanningAppHelper

  MAP_COLS = [{ref: 'app_ref'}, {colour: 'status.colour'},
              {letter: 'category.letter'}, {desc: 'app_description'},
              {lat: 'latitude'}, {long: 'longitude'}]

  def pin_data_hash(apps)
    arr = apps.map do |a|
      MAP_COLS.map(&:values).flatten.map { |s| s.split('.').inject(a, :send) }
    end
    arr.map { |arr| MAP_COLS.map(&:keys).flatten.zip(arr).to_h }
  end

  def all_apps_ordered # all in descending :order
    PlanningApp.order(:order).reverse
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

end # of PlanningAppHelper

Padfoot::App.helpers PlanningAppHelper
