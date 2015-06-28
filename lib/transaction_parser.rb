require 'mechanize'

class TransactionParser

  def initialize(file)
    @file = file
    @agent = Mechanize.new
    @page = page
  end

  def page
    @agent.get(@file)
  end



end
