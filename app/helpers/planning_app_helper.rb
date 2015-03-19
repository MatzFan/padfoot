module PlanningAppHelper

  MAP_COLS = [{ref: :app_ref}, {colour: :app_status}, {letter: :app_category},
              {desc: :app_description}, {lat: :latitude}, {long: :longitude}]


  def pin_colours
    Status.select_hash(:name, :colour)
  end

  def pin_letters
    Category.select_hash(:code, :letter)
  end

  def get_pin_colours_and_letters(arr, col, let)
    arr.each_with_index.map { |e, i| i == 1 ? col[e] : (i == 2 ? let[e] : e) }
  end

  def pin_data_hash(apps)
    colours, letters = pin_colours, pin_letters
    arr = apps.map { |a| MAP_COLS.map(&:values).flatten.map { |m| a.send(m) } }
    arr.map! { |arr| get_pin_colours_and_letters(arr, colours, letters) }
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
