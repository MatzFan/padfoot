require 'curb'

class AddressScraper

  PC_URL = "http://www.jerseypost.com/tools/postcode-address-finder/"
  CLICK = "Click here for address information"

  attr_reader :addresses, :address_arrays

  def initialize(search_string)
    @search_string = search_string
    @num_addresses = num_addresses
    @raw_addresses = raw_addresses
  end

  def raw_addresses
    return [] if num_addresses == 0
    (0..(@num_addresses/100.0).ceil).inject([]) do |memo, i|
      memo << get_addresses_on_page(i).map { |s| s.split(',').map(&:strip) }
    end.first
  end

  def get_addresses_on_page(page_num)
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

  def addresses # remove 'JERSEY' and formats first element to html address
    @raw_addresses.map { |a| [htmlify(a), a[-4], a[-3], a[-1]] }
  end

  def htmlify(arr) # arr is from 4 to 8 elements
    s = arr[0]
    (1..(arr.length - 4)).each do |i| # len must be 6 or more here
      s += arr[i - 1].to_i.to_s == arr[i - 1] ? ' ' + arr[i] : '<br/>' + arr[i]
    end
    s + '<br/>' + arr[-3] + '<br/>' + arr[-1]
  end

end
