require 'mechanize'

class TransactionParser

  HEADER_ROWS = %w(Surname: Maiden\ Name: Summary\ Details: Index: Doc\ Type: Book/Page: Role:)
  PARTY_ROWS = %w(Role Surname/Corporate\ Name Maiden\ Name Forename Extended\ Text)
  PROPERTY_ROWS = %w(Prop\ Id(s) Parish(es) Address(es))
  PARTY_KEYS = [:role, :surname, :maiden_name, :forenames, :ext_text]
  PROP_KEYS = [:uprn, :parish, :address]

  def initialize(file)
    @file = file
    @agent = Mechanize.new
    @page = page
    @tables = tables
    @header_trs = header_trs
    @party_trs = party_trs
    @prop_trs = prop_trs
    fail unless verify_structure
  end

  def verify_structure
    HEADER_ROWS == @header_trs.map { |r| r.children.children[0].text } &&
    PARTY_ROWS == @party_trs.first.children.children.map(&:text) &&
    PROPERTY_ROWS == @prop_trs.first.children.children.map(&:text)
  end

  def page
    @agent.get(@file)
  end

  def tables
    @page.search('table')
  end

  def header_trs
    @tables[2].search('tr')
  end

  def extended_text
    @header_trs[1].children.children.last.text
  end

  def summary_details
    @header_trs[2].children.children.last.text
  end

  def doc_num
    @header_trs[3].children.children.last.text.to_i
  end

  def doc_type
    @header_trs[4].children.children.last.text
  end

  def book_page_text
    @header_trs[5].children.children[1].text.split("\n")
  end

  def book_page
    [book_page_text[2], book_page_text[4]].map &:to_i
  end

  def reg_date_string
    @header_trs[5].children.children.last.text
  end

  def reg_date
    Date.strptime(reg_date_string, '%d/%m/%Y')
  end

  def party_trs
    @tables[5].search('tr')
  end

  def parties
    @party_trs[1..-1].map { |r| r.children.children.map(&:text).map(&:strip) }
  end

  def party_data
    parties.map { |party| Hash[*PARTY_KEYS.zip(party).flatten] }
  end

  def prop_trs
    @tables[7].search('tr')
  end

  def properties
    @prop_trs[1..-1].map { |r| r.children.children.map(&:text).map(&:strip) }
  end

  def property_data
    properties.map { |property| Hash[*PROP_KEYS.zip(property).flatten] }
  end

end
