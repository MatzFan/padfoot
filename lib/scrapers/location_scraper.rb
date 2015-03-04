require 'mechanize'

class LocationScraper

  ID = '19961'
  CODE = 'e6m6h6'
  URL = 'https://www.dataprotection.gov.je/cms/iFrameNotification/'
  ID_FIELD = :'_ctl0:cphContent:InitialPage:txt_company_id'
  CODE_FIELD = :'_ctl0:cphContent:InitialPage:txt_security_code'
  ADDRESS_SEARCH_TXT_FIELD = :'_ctl0:cphContent:CompanyDetail:lpi_contact_address:txt_search'
  FORM = 'aspnetForm'
  PARISH_FIELD = '_ctl0:cphContent:CompanyDetail:lpi_contact_address:drp_parish'
  RESULTS_ID = '_ctl0_cphContent_CompanyDetail_lpi_contact_address_lb_results'
  RESULTS_FIELD = '_ctl0:cphContent:CompanyDetail:lpi_contact_address:lb_results'
  ADD_ID = '_ctl0_cphContent_CompanyDetail_lpi_contact_address_txt_address'
  ADDRESS_COUNT = '_ctl0_cphContent_CompanyDetail_lpi_contact_address_lbl_count'
  PARISHES = %w(Grouville St.\ Brelade St.\ Clement St.\ Helier St.\ John St.\ Lawrence St.\ Martin St.\ Mary St.\ Ouen St.\ Peter St.\ Saviour Trinity)

  attr_reader :agent, :parishes

  def initialize(search_string, parish_num = 0)
    @search_string = search_string
    @parish_num = parish_num.to_i # 0 selects 'any parish'
    @agent = Mechanize.new
    @page_6 = page_6 # where the action is!
    @results_page = results_page
    @form = @results_page.form(FORM)
  end

  def login_page
    page = @agent.get(URL)
    form = page.form(FORM)
    form.send(ID_FIELD, ID) # use send as method (form field) name can be arbitrary string
    form.send(CODE_FIELD, CODE) # ditto
    @agent.submit(form, form.buttons.first)
  end

  def page_5
    form = login_page.form(FORM)
    @agent.submit(form, form.buttons.last)
  end

  def page_6
    form = page_5.form(FORM)
    @agent.submit(form, form.buttons.last)
  end

  def results_page # returns a Page object
    form = @page_6.form(FORM)
    form.send(ADDRESS_SEARCH_TXT_FIELD, @search_string)
    form.field_with(name: PARISH_FIELD).options[@parish_num].select
    @agent.submit(form, form.buttons.first)
  end

  def count
    @results_page.search('#' + ADDRESS_COUNT).children.to_s.split(' ')[0].to_i
  end

  def uprns
    @results_page.search('#' + RESULTS_ID).css('option').map do |e|
      e.attribute('value').content.to_i # strips '-1' from RHS
    end
  end

  def addresses
    (0...count).map { |i| postcode_and_parishify(address(i)) }
  end

  def postcode_and_parishify(arr)
    [arr.join("<br/>"), parish(arr), (arr.last if arr.last =~ /^JE\d \d[A-Z]{2}$/)]
  end

  def parish(arr)
    arr.reverse.each do |string|
      index = PARISHES.index(string)
      return (index + 1) if index
    end
    nil
  end

  def address(num)
    @form.field_with(name: RESULTS_FIELD).options[num].select
    @form.add_field!('__EVENTTARGET', RESULTS_FIELD.gsub(':', '$'))
    @agent.submit(@form).search('#' + ADD_ID).children.to_s.strip.split("\r\n")
  end

  def data
    uprns.zip(addresses)
  end

end
