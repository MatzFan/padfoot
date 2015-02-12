module PlanningAppHelper

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
