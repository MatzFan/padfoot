require 'open-uri'

class BusStopParser

  URI = 'http://www.libertybus.je/jersey.php' # where bus stop data lives

  def initialize
    @source = source
    @places = places
  end

  def source
    open(URI).read
  end

  def office_layer # var name fro bus stop data is 'officeLayer'
    @source.match(/var\s+officeLayer\s+=\s+(.*?);/m)[1]
  end

  def remove_pesky_trailing_commas(text)
    text.gsub(/},\s+\]/, '}]')
  end

  def json # returns Array
    JSON.parse remove_pesky_trailing_commas(office_layer)
  end

  def places
    json[3]['places'] # 4th element has all stops (mx zoom)
  end

  def name_code(string)
    string.split("\nBus stop code - ")
  end

  def codes
    @places.map { |e| name_code(e['name']).last.to_i.to_s }
  end

  def names
    @places.map { |e| name_code(e['name']).first }
  end

  def coords
    @places.map { |e| e['posn'] }
  end

  def data
    clean(codes.zip(names).each_with_index { |e, i| e << coords[i] })
  end

  def clean(arr)
    arr.reject { |e| e.first == '0' } # removes entries with missing code
  end

end
