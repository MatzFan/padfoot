module Plottable # for objects which can be plotted as pushpins

  def get_pin_colours(arr, colours)
    arr.each_with_index.map do |e, i|
      i == 1 ? (colours ? colours[e] : 'orange') : e # default pin colour
    end
  end

  def get_pin_letters(arr, letters)
    arr.each_with_index.map do |e, i|
      i ==  2 ? (letters ? letters[e] : 'P') : e # default pin letter
    end
  end

  def pin_data_hash(objs)
    pin_cols = self.const_get(:PUSHIN_COLUMNS)
    colours, letters = self.pushpin_colours_hash, self.pushpin_letters_hash
    arr = objs.map { |a| pin_cols.map(&:values).flatten.map { |m| a.send(m) } }
    arr.map! { |arr| get_pin_colours(arr, colours) }
    arr.map! { |arr| get_pin_letters(arr, letters) }
    arr.map { |arr| pin_cols.map(&:keys).flatten.zip(arr).to_h }
  end

end
