describe BusTimetableScraper do

  let(:scraper) { BusTimetableScraper.new }
  let(:route_1) { scraper.timetable_page(0) }
  let(:titles) { ["Liberation Station - Gorey Pier - Outbound - Monday-Friday",
                  "Gorey Pier - Liberation Station  - Inbound - Monday-Friday",
                  "Liberation Station - Gorey Pier - Outbound - Saturday",
                  "Gorey Pier - Liberation Station  - Inbound - Saturday",
                  "Liberation Station - Gorey Pier - Outbound - Sunday",
                  "Gorey Pier - Liberation Station  - Inbound - Sunday"]
                }

  context '#new' do
    it 'returns an instance of the class' do
      expect(scraper.class).to eq BusTimetableScraper
    end
  end

  context '#main_title' do
    it 'returns the title of the latest timetable' do
      expect(scraper.main_title).to eq 'Winter Timetable, updated from 12 October 2015'
    end
  end

  context '#routes' do
    it 'returns the title of the latest timetable' do
      expect(scraper.routes.count).to eq 21
    end
  end

  context '#links' do
    it 'returns an array of links to each timetable' do
      expect(scraper.links.first).to eq '/routes_times/timetables/1/FALSE'
    end
  end

  context '#names' do
    it 'returns an array of route names' do
      expect(scraper.names.first).to eq 'Liberation Station - Gorey Pier'
    end
  end

  context '#timetable_page' do
    it 'returns a Mechanize::Page for the given route index' do
      expect(scraper.timetable_page(0).title).to eq 'Liberty Bus - Timetables'
    end
  end

  context '#timetable_titles' do
    it 'returns the title of the given timetable' do
      expect(scraper.timetable_titles(route_1)).to eq titles
    end
  end

  context '#headers_tables' do
    it 'returns the headers tables for the given timetable' do
      expect(scraper.header_tables(route_1).count).to eq 6
    end
  end

  context '#times_tables' do
    it 'returns the times tables for the given timetable' do
      expect(scraper.times_tables(route_1).count).to eq 6
    end
  end

end
