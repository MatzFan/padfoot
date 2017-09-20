# for objects which can be plotted as pushpins
module PushpinPlottable
  PIN_DATA = %i[infoboxTitle colour letter infoboxContent lat long].freeze

  def get_pin_colours(arr, colours)
    arr.each_with_index.map do |e, i|
      i == PIN_DATA.index(:colour) ? (colours ? colours[e] : 'orange') : e
    end
  end

  def get_pin_letters(arr, letters)
    arr.each_with_index.map do |e, i|
      i == PIN_DATA.index(:letter) ? (letters ? letters[e] : 'P') : e
    end
  end

  def pin_data_hash(objs)
    pin_columns = Hash[PIN_DATA.zip const_get(:PUSHIN_COLUMNS)] # assumed - BAD
    colours = pushpin_colours_hash
    letters = pushpin_letters_hash
    arr = objs.map { |a| pin_columns.values.map { |m| a.send(m) } }
    arr.map! { |e| get_pin_colours(e, colours) }
    arr.map! { |e| get_pin_letters(e, letters) }
    arr.map { |e| Hash[PIN_DATA.zip(e)] }
  end
end
