require 'mechanize'

class TransactionTableParser

  KEYS = [:reg_date, :book_num, :page_num, :doc_type]

  def initialize(file)
    @file = file
    @agent = Mechanize.new
    @page = page
  end

  def page
    @agent.get(@file)
  end

  def row_data
    @page.search('table tr')[1..-1].map { |r| r.children.children }
  end

  def columns
    row_data.map { |r| [r[3], r[4], r[5], r[7]] }
  end

  def data
    columns.map { |r| r.map(&:text) }
  end

end
