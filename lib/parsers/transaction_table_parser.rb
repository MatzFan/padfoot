require 'mechanize'

class TransactionTableParser

  SEQ = [:nameSeq, :docSeq]
  KEYS = [{pa: 1}, {date: 3}, {book_num: 4}, {page_num: 5}, {e: 6}, {type: 8}]

  def initialize(file)
    @uri = URI.join('file:///', file)
    @agent = Mechanize.new
    @page = page
    @rows = rows
    @sequence_data = sequence_data
  end

  def page
    @agent.get(@uri)
  end

  def rows
    @page.search('table tr')[1..-1] # skip title row
  end

  def number
    @rows.size
  end

  def sequence_data
    @rows.map { |r| parse r.elements[0].children[0].attribute('href').value }
  end

  def parse(text) # parses nameSeq & docSeq
    Hash[SEQ.map { |k| [k, text.match(/#{k}=(\d+)/).to_a[1].to_i] }]
  end

  def row_text
    @rows.map { |r| r.search('td').map(&:text) }
  end

  def data
    row_text.each_with_index.map do |r, i|
      Hash[KEYS.map {|h| [h.keys[0], process(r[h.values[0]], i) ]}]
    end
  end

  def all_data
    data.each_with_index.map { |h, i| h.merge @sequence_data[i] }
  end

  def process(text, i)
    text.strip!
    return nil if text.empty?
    return DateTime.parse(text).to_date if text =~ /\d{2}\/\d{2}\/\d{4}/
    return text.to_i if text =~ /^\d+$/
    return page_suffix(text, i) if text =~ /^\d{1,3}\/[A-Z]{1}/  # eg: "339/A"
    text
  end

  def page_suffix(text, i)
    page_num, suffix = text.split('/')
    @sequence_data[i].merge!({page_suffix: suffix}) # add page_suffix to hash
    page_num.to_i
  end

end
