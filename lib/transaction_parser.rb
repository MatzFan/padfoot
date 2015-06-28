require 'mechanize'

class TransactionParser

  HEADER_ROWS = %w(Surname: Maiden\ Name: Summary\ Details: Index: Doc\ Type: Book/Page: Role:)
  PARTY_ROWS = %w(Role Surname/Corporate\ Name Maiden\ Name Forename Extended\ Text)
  PROPERTY_ROWS = %w(Prop\ Id(s) Parish(es) Address(es))

  def initialize(file)
    @file = file
    @agent = Mechanize.new
    @page = page
    @tables = tables
    @header_table_rows = header_table_rows
    @party_table_rows = party_table_rows
    @property_table_rows = property_table_rows
    fail unless verify_structure
  end

  def verify_structure
    HEADER_ROWS == @header_table_rows.map { |r| r.children.children[0].text } &&
    PARTY_ROWS == @party_table_rows.first.children.children.map(&:text) &&
    PROPERTY_ROWS == @property_table_rows.first.children.children.map(&:text)
  end

  def page
    @agent.get(@file)
  end

  def tables
    @page.search('table')
  end

  def header_table_rows
    @tables[2].search('tr')
  end

  def doc_num
    @header_table_rows[3].children.children.last.text.to_i
  end

  def doc_type
    @header_table_rows[4].children.children.last.text
  end

  def doc_type
    @header_table_rows[4].children.children.last.text
  end

  def party_table_rows
    @tables[5].search('tr')
  end

  def parties
    @party_table_rows[1..-1].map { |r| r.children.children.map(&:text) }
  end

  def property_table_rows
    @tables[7].search('tr')
  end

  def properties
    @property_table_rows[1..-1].map { |r| r.children.children.map(&:text) }
  end

end
