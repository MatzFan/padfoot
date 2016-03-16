# parser for javascript-sourced rtf files of transaction data
class TransactionParser
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

  def parties(transaction)
    transaction[1].split("\n")[1..-1].each_slice(5).map { |a| partify(a) }
  end

  def properties(transaction)
    transaction[2].split("\n")[1..-1].each_slice(5).map { |a| propify(a) }
  end

  def partify(arr)
    Hash[PARTY_KEYS.zip(remove_delimiters(arr))]
  end

  def propify(arr)
    Hash[PROP_KEYS.zip(remove_delimiters(arr))]
  end

  def remove_delimiters(array)
    array.map { |e| e[1..-2] } # turns '>some text<' into 'some text'
  end
end
