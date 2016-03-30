# require 'mechanize'

# class UprnScraper
#   ID = '19961'
#   CODE = 'e6m6h6'
#   URL = 'https://www.dataprotection.gov.je/cms/iFrameNotification/'
#   ID_FIELD = :'_ctl0:cphContent:InitialPage:txt_company_id'
#   CODE_FIELD = :'_ctl0:cphContent:InitialPage:txt_security_code'
#   ADDRESS_SEARCH_TXT_FIELD = :'_ctl0:cphContent:CompanyDetail:lpi_contact_address:txt_search'
#   FORM = 'aspnetForm'
#   PARISH_FIELD = '_ctl0:cphContent:CompanyDetail:lpi_contact_address:drp_parish'
#   RESULTS_ID = '_ctl0_cphContent_CompanyDetail_lpi_contact_address_lb_results'
#   RESULTS_FIELD = '_ctl0:cphContent:CompanyDetail:lpi_contact_address:lb_results'
#   ADD_ID = '_ctl0_cphContent_CompanyDetail_lpi_contact_address_txt_address'
#   COUNT = '_ctl0_cphContent_CompanyDetail_lpi_contact_address_lbl_count'

#   attr_reader :agent, :parishes

#   def initialize(search_string, parish_num = 0)
#     @search_string = search_string
#     @parish_num = parish_num.to_i # 0 selects 'any parish'
#     @agent = Mechanize.new
#     @page_6 = page_6 # where the action is!
#     @results_page = results_page
#     @form = @results_page.form(FORM)
#   end

#   def login_page
#     page = @agent.get(URL)
#     form = page.form(FORM)
#     form.send(ID_FIELD, ID) # use send as method (form field) name can be arb
#     form.send(CODE_FIELD, CODE) # ditto
#     @agent.submit(form, form.buttons.first)
#   end

#   def page_5
#     form = login_page.form(FORM)
#     @agent.submit(form, form.buttons.last)
#   end

#   def page_6
#     form = page_5.form(FORM)
#     @agent.submit(form, form.buttons.last)
#   end

#   def results_page # returns a Page object
#     form = @page_6.form(FORM)
#     form.send(ADDRESS_SEARCH_TXT_FIELD, @search_string)
#     form.field_with(name: PARISH_FIELD).options[@parish_num].select
#     @agent.submit(form, form.buttons.first)
#   end

#   def count
#     text = @results_page.search('#' + COUNT).children.to_s.split(' ')[0]
#     text == 'More' ? 50 : text.to_i
#   end

#   def uprns
#     @results_page.search('#' + RESULTS_ID).css('option').map do |e|
#       e.attribute('value').content.to_i # strips '-1' from RHS
#     end
#   end

#   def addresses
#     (0...count).map { |i| parse(address(i)) }
#   end

#   def parse(arr)
#     postcode = postcode(arr[-1])
#     parish = parish(arr)
#     road = (postcode ? arr[-3] : (parish ? arr[-2] : arr[-1]))
#     [arr.join('<br/>'), road, parish, postcode]
#   end

#   def postcode(string)
#     postcode = /^JE\d \d[A-Z]{2}$/.match(string)
#     postcode ? postcode.to_s : nil
#   end

#   def parish(arr)
#     arr.reverse_each do |string|
#       index = Parish.select_map(:name).index(string)
#       return (index + 1) if index
#     end
#     nil
#   end

#   def address(num)
#     @form.field_with(name: RESULTS_FIELD).options[num].select
#     @form.add_field!('__EVENTTARGET', RESULTS_FIELD.tr(':', '$'))
#     @agent.submit(@form).search('#' + ADD_ID).children.to_s.strip.split("\r\n")
#   end

#   def data
#     uprns.zip(addresses)
#   end
# end

# # s = UprnScraper.new('fourneaux')
# # puts s.data
