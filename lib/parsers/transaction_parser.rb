require 'mechanize'

class TransactionParser

  HEADER_ROWS = %w(Surname: Maiden\ Name: Summary\ Details: Index: Doc\ Type: Book/Page: Role:)
  PARTY_ROWS = %w(Role Surname/Corporate\ Name Maiden\ Name Forename Extended\ Text)
  PROPERTY_ROWS = %w(Prop\ Id(s) Parish(es) Address(es))
  PARTY_KEYS = [:role, :surname, :maiden_name, :forename, :ext_text]
  PROP_KEYS = [:property_uprn, :parish, :address]

  def initialize(file)
    @uri = URI.join('file:///', file)
    @agent = Mechanize.new
    @page = page
    @tables = tables
    @header_trs = header_trs
    @party_trs = party_trs
    @prop_trs = prop_trs
    fail unless verify_structure
    @book_page_suffix = book_page_suffix
    @parties = parties
    @maiden_names = maiden_names
    @properties = properties
  end

  def verify_structure
    HEADER_ROWS == @header_trs.map { |r| r.children.children[0].text } &&
    PARTY_ROWS == @party_trs.first.children.children.map(&:text) &&
    PROPERTY_ROWS == @prop_trs.first.children.children.map(&:text)
  end

  def page
    page = @agent.get(@uri)
    page.encoding = 'utf-8'
    page
  end

  def tables
    @page.search('table')
  end

  def header_trs
    @tables[2].search('tr')
  end

  def extended_text
    arr = @header_trs[1].search('td').last.children
    arr.first.text if !arr.empty?
  end

  def summary_details
    arr = @header_trs[2].search('td').last.children
    arr.first.text if !arr.empty?
  end

  def doc_num
    arr = @header_trs[3].search('td').last.children
    arr.first.text.to_i if !arr.empty?
  end

  def doc_type
    @header_trs[4].children.children.last.text
  end

  def book_page_text
    @header_trs[5].children.children[1].text.split("\n").values_at(2,4)
  end

  def book_page_suffix
    book_num_text, page_num_suffix = book_page_text
    page_num_text, suffix = page_num_suffix.split('/')
    [book_num_text.to_i, page_num_text.to_i, suffix]
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
    @party_trs[1..-1].map do |row|
      nils row.search('td').to_a.values_at(0,2,4,6,8).map(&:text).map(&:strip)
    end
  end

  def nils(arr)
    arr.map { |string| string.empty? ? nil : string }
  end

  def parties_data
    parties_less_maidens.map { |party| Hash[*PARTY_KEYS.zip(party).flatten] }
  end

  def parties_less_maidens
    raise "Maiden ext_text: #{@book_page_suffix}" if @maiden_names.any? &:last
    @parties - @maiden_names
  end

  def maiden_names
    married_names.map { |arr| [arr[0], arr[2], nil, arr[3], arr[4]] }
  end

  def married_names
    @parties.reject { |a| a[2].nil? }
  end

  def prop_trs
    @tables[7].search('tr')
  end

  def properties
    @prop_trs[1..-1].map { |r| r.children.children.map(&:text).map(&:strip) }
  end

  def properties_data
    @properties.map { |property| Hash[*PROP_KEYS.zip(property).flatten] }
  end

end
