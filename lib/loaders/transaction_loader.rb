# loads data for a single transaction into Transactions & related tables
class TransactionLoader
  KEYS = [:book_num, :page_num, :page_suffix].freeze
  NAME_KEYS = [:forename, :surname, :maiden_name].freeze
  class LoadError < StandardError; end

  def initialize(data) # TransactionParser.data
    @data = data
    @details, @parties, @properties = *data
    @bk, @page, @suf = *KEYS.map { |k| @details.send(:[], k) }
    @trans = trans
    @t = @trans.id
  end

  def write
    write_transaction
    write_parties
    write_properties
  end

  def trans
    t = Transaction.find(book_num: @bk, page_num: @page, page_suffix: @suf)
    t ? t : (raise LoadError, "Transaction not found: #{@bk}, #{@page}/#{@suf}")
  end

  def write_transaction
    @trans.update(summary_details: @details[:summary_details])
  end

  def write_parties
    @parties.each { |p| write_nt fc_name(n_hash(p)).id, p[:ext_text], p[:role] }
  end

  def write_nt(i, t, r)
    NamesTransaction.create transaction_id: @t, name_id: i, ext_text: t, role: r
  end

  def n_hash(party)
    party.select { |k, _| NAME_KEYS.any? { |n| n == k } }
  end

  def fc_name(hash)
    Name.find_or_create hash
  end

  def write_properties
    @properties.each { |p| @trans.add_trans_prop(TransProp.new(p)) }
  end
end
