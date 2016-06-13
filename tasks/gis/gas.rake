require_relative '_gis_helper'

namespace :sq do
  namespace :gps do
    desc 'Creates and populates 6 tables from JerseyUtilities/JerseyUtilities Jersey Gas MapServer layers'
    task :gas do
      url = 'https://gps.digimap.gg/arcgis/rest/services/JerseyUtilities/JerseyUtilities/MapServer/129'
      GisHelper.configure
      DB.transaction do
        LayerWriter.new(url).output_to_db
      end
    end
  end
end
