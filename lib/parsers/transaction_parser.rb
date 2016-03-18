# parser for javascript-sourced rtf files of transaction data
class TransactionParser
  class ParserError < StandardError; end

  DET_KEYS = [:summary_details, :book_num,
                  :page_num, :page_suffix, :date, :type].freeze
  PARTY_KEYS = [:role, :surname, :forename, :maiden_name, :ext_text].freeze
  PROP_KEYS = [:property_uprn, :parish, :add_1, :add_2, :add_3].freeze
  METHODS = [:details, :parties, :properties].freeze
  DET_N = 30 # number of details fields in details text
  PAR_N = 5 # number of parties fields in parties text
  PROP_N = 5 # number of properties fields in properties text
  D1 = '>'.freeze
  D2 = '<'.freeze
  EMPTY_FIELD = D1 + D2
  TABLE_REGEX = /#{D2}[A-Z]{3}#{D1}/
  UPRN_REGEX = /\d{8}/

  def initialize(file_path)
    @file_path = file_path
    @file_text = file_text
    @transactions = transactions
    @parishes = parishes
  end

  def file_text
    IO.read @file_path
  end

  def transactions
    @file_text.split("|\n").map { |s| details_parties_properties s }
  end

  def parishes
    Parish.select_map :name
  end

  def data
    @transactions.map { |t| transaction_data(t) } # t is 3 element array
  end

  def transaction_data(t)
    t.each_with_index.map { |e, i| send(METHODS[i], e) }
  end

  def details_parties_properties(string)
    string.split(TABLE_REGEX)[1..-1]
  end

  def details(details_text) # returns sum_dets, book, page(suffix), date, type
    raise ParserError unless (f = split_newlines(details_text)).size == DET_N
    detailify f.values_at(9, 11, 13, 15, 23)
  end

  def detailify(arr)
    Hash[DET_KEYS.zip(process_page_suffix(remove_delims(arr).map(&:strip)))]
  end

  def process_page_suffix(arr)
    arr[0..1] + split_suffix(arr[2]) + arr[3..4]
  end

  def split_suffix(string)
    arr = string.split('/')
    arr[1] ? arr : arr << ''
  end

  def parties(party_text) # checks fields are multiple of 5
    raise ParserError unless (f = split_newlines(party_text)).size % PAR_N == 0
    f.each_slice(PAR_N).map { |a| partify(a) }
  end

  def partify(arr)
    Hash[PARTY_KEYS.zip(remove_delims(arr).map(&:strip))]
  end

  def properties(props_text)
    return [] if props_text == "\n\n" # there are no properties
    raise ParserError unless (f = missing_uprns(props_text)).size % PROP_N == 0
    f.each_slice(PROP_N).map { |a| propify(a) }
  end

  def missing_uprns(props_text)
    fields = split_newlines(props_text)
    n = 0
    loop do
      return fields unless fields[n]
      if fields[n] !~ UPRN_REGEX
        raise ParserError unless parishes.any? { |p| fields[n] == D1 + p + D2 }
        fields.insert(n, EMPTY_FIELD)
      end
      n += 5
    end
  end

  def propify(arr)
    Hash[PROP_KEYS.zip(remove_delims(arr).map(&:strip))]
  end

  private

  def split_newlines(text)
    text.split("\n")[1..-1]
  end

  def remove_delims(array)
    array.map { |e| e[1..-2] } # turns '>some text<' into 'some text'
  end
end
