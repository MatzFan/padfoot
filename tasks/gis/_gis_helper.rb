require 'gis_scraper'

SERVER = 'http://dcw7.digimap.je/arcgis/rest/services/'.freeze

GisScraper.configure(dbname: 'jersey', srs: 'EPSG:3109')
