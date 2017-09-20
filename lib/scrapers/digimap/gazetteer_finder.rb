require_relative 'digimap_scraper'

# class to scrape gazetteer
class GazetteerFinder < DigimapScraper
  include Mappable # REALLY WANT TO DO THIS?????????????

  URL = 'JerseyAddressLocator/JerseyMappingOL/MapServer/find'.freeze
  FORM_FIELDS = %w[searchText layers f].freeze
  FORM_RADIOS = [].freeze

  def initialize(min = nil, max = nil, validate_fields: false) # make min & max optional in superclass..
    super
  end

  def json_for(search_text)
    fill_form_with(search_text)
    @form.submit(@form.buttons[0]).json # GET button
  end

  def fill_form_with(search_text)
    @form.field_with(name: 'searchText').value = search_text
    @form.field_with(name: 'layers').value = 'Gazetteer'
    @form.field_with(name: F).value = 'pjson'
  end

  def results_for(search_text)
    add_locations_to json_for(search_text)['results']
  end

  def add_locations_to(results)
    geoms = results.map { |r| r['geometry'] }
    xs = geoms.map { |g| g['x'] }
    ys = geoms.map { |g| g['y'] }
    lat_longs = transform_xy(xs, ys)
    locs = lat_longs.map do |ll|
      { 'location' => { 'lat' => ll.first, 'lng' => ll.last } }
    end
    results.each_with_index.map do |r, i|
      r.merge('geometry' => geoms[i].merge(locs[i]))
    end
  end
end
