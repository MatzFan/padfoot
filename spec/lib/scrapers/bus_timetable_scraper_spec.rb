describe BusTimetableScraper do

  scraper = BusTimetableScraper.new
  route_4_timetables = scraper.timetables(6)
  let(:route_1_page) { scraper.timetable_pages[0] }
  let(:route_numbers) { %w(1 1a 1g 2 2a 3 4 5 7 7a 8 9 12 13 15 16 19 21 22 x22 23) }
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
    it 'returns an array of <a> elements for the 21 routes' do
      expect(scraper.routes.count).to eq 21
    end
  end

  context '#links' do
    it 'returns an array of links to each timetable' do
      expect(scraper.links.first).to eq '/routes_times/timetables/1/FALSE'
    end
  end

  context '#rte_nums' do
    it 'returns an array of the route numbers' do
      expect(scraper.rte_nums).to eq route_numbers
    end
  end

  context '#route_names' do
    it 'returns an array of route names' do
      expect(scraper.route_names.first).to eq 'Liberation Station - Gorey Pier'
    end
  end

  context '#timetable_pages' do
    it 'returns an array of Mechanize::Pages for each route timetable page' do
      expect(scraper.timetable_pages[0].title).to eq 'Liberty Bus - Timetables'
    end
  end

  context '#titles' do
    it 'returns the title of the given timetable' do
      expect(scraper.titles(0)).to eq titles
    end
  end

  context '#days' do
    it 'returns "Weekdays" if index provided is < 2' do
      expect(scraper.days(1)).to eq 'Weekdays'
    end

     it 'returns "Saturdays" if index provided is > 1 and < 4' do
      expect(scraper.days(3)).to eq 'Saturday'
    end

     it 'returns "Sunday" if index provided is > 3 and < 6' do
      expect(scraper.days(5)).to eq 'Sunday'
    end

    it 'raises ArgumentError if index > 5' do
      expect(->{scraper.days(6)}).to raise_error(ArgumentError)
    end
  end

  context '#header_table_rows' do
    it 'returns a 2D array of headers table rows for each timetable for the given route index' do
      expect(scraper.header_table_rows(6).map &:count).to eq [52, 35, 40, 27] # no Sunday service for route 4
    end
  end

  context '#times_table_rows' do
    it 'returns the times tables for the given timetable' do
      expect(scraper.times_table_rows(6).map &:count).to eq [52, 35, 40, 27] # no Sunday service for route 4
    end
  end

  context '#data' do
    it 'returns a 2D array of stop code and arrival time data for given route and timetable indices' do
      expect(scraper.data(6, 0).first).to eq ['2757', [nil, nil, nil, nil, nil, '15:15', nil, nil, nil, nil]]
    end
  end

  context '#timetables' do
    it 'returns an array of 4 element arrays - one for each timetable for the given route index' do
      expect(route_4_timetables.all? { |e| e.size == 4 }).to eq true
    end

    it 'the value for the array first element is the route number' do
      expect(route_4_timetables.map &:first).to eq ['4', '4', '4', '4']
    end

    it 'the value for the array second element is "In" or "Out"' do
      expect(route_4_timetables.map { |e| e[1] }).to eq %w(Out In Out In)
    end

    it 'the value for the array third element is "Weekdays", "Saturday" or "Sunday"' do
      expect(route_4_timetables.map { |e| e[2] }).to eq %w(Weekdays Weekdays Saturday Saturday)
    end

     it 'the value for the array fourth element is an 2D array of stop codes and times' do
      expect(route_4_timetables.map { |e| e[3] }.last.last).to eq ["2465", ["08:30", "10:00", "12:00", "14:00", "15:20", "16:50", "17:35", "19:05", "20:30"]]
    end
  end

end
