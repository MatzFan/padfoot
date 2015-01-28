module PlanningAppHelper

  def div_wrap_strings_in(app, lines) # returns a hash
    app.map { |e| e.class == String ? fix_height_div_wrap(e,lines) : e }
  end

  def fix_height_div_wrap(txt, lines, options = {})
    options = defaults.merge(options)
    font, hght, pad = options[:font], options[:line_height], options[:padding]
    pixels = ((lines - 1)*hght*font + font + 2*pad).ceil
    "<div style='height:#{pixels}px; overflow:scroll'>#{txt}</div>"
  end

  def defaults
    {font: 12, line_height: 1.42857143, padding: 2}
  end

end # of PlanningAppHelper

Padfoot::App.helpers PlanningAppHelper
