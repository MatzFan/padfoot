describe BusTimetableScraper do

  let(:scraper) { BusTimetableScraper.new }

  context '#new' do
    it 'returns an instance of the class' do
      expect(scraper.class).to eq BusTimetableScraper
    end
  end

  context '#title' do
    it 'returns the title of the latest timetable' do
      expect(scraper.title).to eq 'Winter Timetable, updated from 12 October 2015'
    end
  end

  context '#routes' do
    it 'returns the title of the latest timetable' do
      expect(scraper.routes.count).to eq 21
    end
  end

  context '#route_links' do
    it 'returns an array of links to each timetable' do
      expect(scraper.route_links.first).to eq '/routes_times/timetables/1/FALSE'
    end
  end

  context '#route_names' do
    it 'returns an array of route names' do
      expect(scraper.route_names.first).to eq 'Liberation Station - Gorey Pier'
    end
  end

end
