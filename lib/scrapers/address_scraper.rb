require 'open-uri'

# scrapes Jersey postal addresses
class AddressScraper
  BASEURL = 'http://www.jerseypost.com/tools/postcode-address-finder/?'.freeze
  CLICK = 'Click here for address information'.freeze
  FIND = 'Find+an+Address'.freeze

  attr_reader :addresses, :address_arrays

  def initialize(search_string)
    @search_string = search_string
    @num_addresses = num_addresses
    @raw_adds = raw_adds
  end

  def raw_adds
    return [] if num_addresses == 0
    (0..(@num_addresses / 100.0).ceil).inject([]) do |memo, i|
      memo << adds_on_page(i).map { |s| s.split(', ').map(&:strip) } # ', '
    end.first
  end

  def adds_on_page(page_num)
    address_block = source(page_num).match(%r{#{CLICK}">(.*)</select>}mu)[1]
    adds = address_block.split(%r{</?option>}).map(&:strip)
    adds.values_at(* adds.each_index.select(&:odd?)) # even ones are ""
  end

  def num_addresses
    # source = source(0).force_encoding(Encoding::UTF_8)
    num = source(0).match(/<h3>There (are|is only) <span>(.*) result/)[2]
    num == 'no' ? 0 : num.to_i
  end

  def source(page_num)
    url = "#{BASEURL}&string=#{@search_string}&search=#{FIND}&first=#{page_num}"

    open(url).read.force_encoding(Encoding::UTF_8)
  end

  def addresses # remove 'JERSEY', separate road, parish and postcode
    @raw_adds.map do |arr|
      parish_num = parish_num(arr[-3])
      [htmlify(arr), (arr[-4] if parish_num), parish_num, arr[-1]]
    end
  end

  def parish_num(string)
    num = Parish.select_map(:name).index(string)
    num + 1 if num
  end

  def htmlify(arr) # arr is from 4 to 9 elements
    s = arr[0]
    n = arr.length - 4
    (1..n).each { |i| s += int?(arr[i - 1]) ? ' ' + arr[i] : '<br/>' + arr[i] }
    # add parish & postcode
    s + (arr[-3].empty? ? '' : '<br/>' + arr[-3]) + '<br/>' + arr[-1]
  end

  def int?(string)
    string.to_i.to_s == string
  end
end
