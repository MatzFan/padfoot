require_relative 'maintenance_helper'

AppRefsScraper.new(2014, '2174').latest_refs.each do |ref|
  Application.find_or_create(app_ref: ref)
end
