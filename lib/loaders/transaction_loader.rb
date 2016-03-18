# loads data for a single transaction into Transactions & related tables
class TransactionLoader
  KEYS = [:book_num, :page_num, :page_suffix].freeze
  T = Transaction
  class LoadError < StandardError; end

  def initialize(data) # TransactionParser.data
    @data = data
    @details, @parties, @properties = *data
    @bk, @page, @suf = *KEYS.map { |k| @details.send(:[], k) }
    @trans = trans
  end

  def trans
    t = T.find(book_num: @bk, page_num: @page, page_suffix: @suf)
    t ? t : (raise LoadError, "Transaction not found: #{@bk}, #{@page}/#{@suf}")
  end

  def write_trans
    @trans.update(summary_details: @details[:summary_details])
  end

  def write_parties
  end

  def write_properties
    @properties.each { |p| @trans.add_trans_prop(TransProp.new(p)) }
  end
end
