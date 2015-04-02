module PushpinPlottable # for objects which can be plotted as pushpins

  PIN_DATA = [:infoboxTitle, :colour, :letter, :infoboxContent, :latitude, :longitude] # GetMap JS expects these keys to plot a pushpin

  def get_pin_colours(arr, colours)
    arr.each_with_index.map do |e, i|
      i == PIN_DATA.index(:colour) ? (colours ? colours[e] : 'orange') : e # default pin colour
    end
  end

   def get_pin_letters(arr, letters)
    arr.each_with_index.map do |e, i|
      i == PIN_DATA.index(:letter) ? (letters ? letters[e] : 'P') : e # default pin letter
    end
  end

  def pin_data_hash(objs)
    pin_columns = Hash[PIN_DATA.zip self.const_get(:PUSHIN_COLUMNS)]
    colours, letters = self.pushpin_colours_hash, self.pushpin_letters_hash
    arr = objs.map { |a| pin_columns.values.map { |m| a.send(m) } }
    arr.map! { |arr| get_pin_colours(arr, colours) }
    arr.map! { |arr| get_pin_letters(arr, letters) }
    data = arr.map { |arr| Hash[PIN_DATA.zip(arr)] }
  end

end
