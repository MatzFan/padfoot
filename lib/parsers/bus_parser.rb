require 'open-uri'

class BusStopParser

  def initialize(uri)
    @uri = uri
    @source = source
  end

  def source
    open(@uri).read
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
    places.map { |e| name_code(e['name']).last }
  end

  def names
    places.map { |e| name_code(e['name']).first }
  end

  def coords
    places.map { |e| e['posn'] }
  end

end
