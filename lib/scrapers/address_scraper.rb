require 'curb'

class AddressScraper

  PC_URL = "http://www.jerseypost.com/tools/postcode-address-finder/"
  CLICK = "Click here for address information"
  PARISHES = %w(Grouville St.\ Brelade St.\ Clement St.\ Helier St.\ John St.\ Lawrence St.\ Martin St.\ Mary St.\ Ouen St.\ Peter St.\ Saviour Trinity)

  attr_reader :addresses, :address_arrays

  def initialize(search_string)
    @search_string = search_string
    @num_addresses = num_addresses
    @raw_adds = raw_adds
  end

  def raw_adds
    return [] if num_addresses == 0
    (0..(@num_addresses/100.0).ceil).inject([]) do |memo, i|
      memo << adds_on_page(i).map { |s| s.split(', ').map(&:strip) } # note comma + space
    end.first
  end

  def adds_on_page(page_num)
    address_block = source(page_num).match(/#{CLICK}">(.*)<\/select>/mu)[1]
    adds = address_block.split(/<\/?option>/).map(&:strip)
    adds.values_at(* adds.each_index.select { |i| i.odd? }) # need to select only odd values, as even ones are ""
  end

  def num_addresses
    # source = source(0).force_encoding(Encoding::UTF_8)
    num = source(0).match(/<h3>There (are|is only) <span>(.*) result/)[2]
    num == 'no' ? 0 : num.to_i
  end

  def source(page_num)
    Curl.get(PC_URL, {
      string: @search_string,
      search: "Find+an+Address",
      first: page_num
    }).body_str.force_encoding(Encoding::UTF_8)
  end

  def addresses # remove 'JERSEY', separate road, parish and postcode
    @raw_adds.map do |arr|
      parish_num = parish_num(arr[-3])
      [htmlify(arr), (arr[-4] if parish_num), parish_num, arr[-1]]
    end
  end

  def parish_num(string)
    num = PARISHES.index(string)
    num += 1 if num
  end

  def htmlify(arr) # arr is from 4 to 9 elements
    s, n = arr[0], (arr.length - 4)
    (1..n).each { |i| s += int?(arr[i - 1]) ? ' ' + arr[i] : '<br/>' + arr[i] }
    s + (arr[-3].empty? ? '' : '<br/>' + arr[-3]) + '<br/>' + arr[-1] # add parish and postcode
  end

  def int?(string)
    string.to_i.to_s == string
  end

end

# s = AddressScraper.new('je1 1aa')
# puts s.addresses.inspect
