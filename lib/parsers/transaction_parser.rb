# parser for javascript-sourced rtf files of transaction data
class TransactionParser
  DETAILS_KEYS = [:summary_details, :book_num,
                  :page_num, :page_suffix, :date].freeze
  PARTY_KEYS = [:role, :surname, :forename, :maiden_name, :ext_text].freeze
  PROP_KEYS = [:property_uprn, :parish, :add_1, :add_2, :add_3].freeze

  def initialize(file_path)
    @file_path = file_path
    @file_text = file_text
    @transactions = transactions
  end

  def file_text
    IO.read @file_path
  end

  def transactions
    @file_text.split("|\n").map { |s| details_parties_properties s }
  end

  def details_parties_properties(string)
    string.split(/<[A-Z]{3}>/)[1..-1]
  end

  def details(transaction) # returns summary_details, book, page(+suffix), date
    detailify transaction[0].split("\n")[1..-1].values_at(9, 11, 13, 15)
  end

  def detailify(arr)
    Hash[DETAILS_KEYS.zip(process_page_suffix(remove_delims(arr)))]
  end

  def process_page_suffix(arr)
    arr[0..1] + split_suffix(arr[2]) << arr[3]
  end

  def split_suffix(string)
    arr = string.split('/')
    arr[1] ? arr : arr << ''
  end

  def parties(transaction)
    transaction[1].split("\n")[1..-1].each_slice(5).map { |a| partify(a) }
  end

  def partify(arr)
    Hash[PARTY_KEYS.zip(remove_delims(arr))]
  end

  def properties(transaction)
    transaction[2].split("\n")[1..-1].each_slice(5).map { |a| propify(a) }
  end

  def propify(arr)
    Hash[PROP_KEYS.zip(remove_delims(arr))]
  end

  def remove_delims(array)
    array.map { |e| e[1..-2] } # turns '>some text<' into 'some text'
  end
end
