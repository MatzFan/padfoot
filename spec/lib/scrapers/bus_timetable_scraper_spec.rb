describe JavascriptVarsParser do

  let(:source) { Mechanize.new.get 'http://www.libertybus.je/routes_times/timetables'}
  let(:route_numbers) { %w(1 1a 1g 2 2a 3 4 5 7 7a 8 9 12 13 15 16 19 21 22 x22 23) }
  let(:parser) { JavascriptVarsParser.new(source.body, route_numbers, 3) }

  context '#new' do
    it 'returns an instance of the class' do
      expect(parser.class).to eq JavascriptVarsParser
    end
  end

  context '#js_vars_for_special_days' do
    it 'scrapes the JS function vars used to add special days via css' do
      expect(parser.js_vars_for_special_days.size).to eq 57
    end
  end

  context '#route_tt_index' do
    it 'returns an array of the route index and timetable index the special day(s) apply to' do
      expect(parser.route_tt_index("var day='1G-0-friday';")).to eq [2, 0]
    end
  end

  context '#column_days' do
    it 'returns a 2D array of the column(s) the special days apply to and the days (e.g. "School Days Only")' do
      expect(parser.column_days("var columns= {  13:'dusk',19:'sky'};")).to eq [[10, 'School Days Only'], [16, 'Fridays Only']]
    end
  end

  context '#special_days_data' do
    it 'returns a 3D array of special days data' do
      expect(parser.special_days_data.all? { |e| e.all? { |e| e.class == Array } }).to eq true
    end

    it 'only returns data for current routes' do
      expect(parser.special_days_data.size).to eq 14 # Javascript had 19 routes - 5 no longer exist
    end

    it 'where each array has 3 element; 1) [route_num, tt_index] 2) ' do
      expect(parser.special_days_data.last).to eq [[16, 0], [[1, 'School Days Only'], [10, 'School Days Only']]]
    end
  end

end


describe BusTimetableScraper do

  scraper = BusTimetableScraper.new
  let(:route_1_page) { scraper.timetable_pages[0] }
  let(:route_numbers) { %w(1 1a 1g 2 2a 3 4 5 7 7a 8 9 12 13 15 16 19 21 22 x22 23) }
  let(:titles) { ["Liberation Station - Gorey Pier - Outbound - Monday-Friday",
                  "Gorey Pier - Liberation Station  - Inbound - Monday-Friday",
                  "Liberation Station - Gorey Pier - Outbound - Saturday",
                  "Gorey Pier - Liberation Station  - Inbound - Saturday",
                  "Liberation Station - Gorey Pier - Outbound - Sunday",
                  "Gorey Pier - Liberation Station  - Inbound - Sunday"] }
  let(:route_1_bounds) { %w(Outbound Inbound Outbound Inbound Outbound Inbound)}
  let(:route_15_bounds) { Array.new(3) { 'Outbound' } }
  let(:route_1_days) { ['Monday-Friday', 'Monday-Friday', 'Saturday', 'Saturday', 'Sunday', 'Sunday'] }
  let(:special_days) { [[nil, 'School Days Only', nil, nil, nil, nil, nil, nil, nil, nil, 'School Days Only', nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]] }

  let(:stop_times) { [['4524', '07:25'],
                      ['2462', '07:28'],
                      ['3524', '07:29'],
                      ['3847', '07:30'],
                      ['3549', '07:31'],
                      ['3479', '07:31'],
                      ['2639', '07:31'],
                      ['3276', '07:35'],
                      ['2532', '07:35'],
                      ['2568', '07:35'],
                      ['2763', '07:36'],
                      ['2764', '07:36'],
                      ['2496', '07:39'],
                      ['3975', '07:39'],
                      ['2523', '07:42'],
                      ['2794', '07:42'],
                      ['2539', '07:44'],
                      ['2548', '07:44'],
                      ['3498', '07:45'],
                      ['2454', '07:45'],
                      ['3762', '07:46'],
                      ['2785', '07:48'],
                      ['2598', '07:48'],
                      ['2594', '07:49'],
                      ['2465', '07:55']]
                    }

  let(:bus_19_last_on_saturday) { ["19", "Outbound", "Saturday", [
                                    ["4524", "18:10"], ["2462", "18:13"], ["3524", "18:14"], ["3847", "18:16"], ["3549", "18:17"],
                                    ["3479", "18:17"], ["2639", "18:17"], ["3276", "18:18"], ["2532", "18:19"], ["2568", "18:20"],
                                    ["2763", "18:20"], ["2764", "18:21"], ["2496", "18:24"], ["3975", "18:24"], ["2523", "18:26"],
                                    ["2794", "18:26"], ["2539", "18:27"], ["2548", "18:27"], ["3498", "18:32"], ["2454", "18:32"],
                                    ["3762", "18:33"], ["2785", "18:35"], ["2598", "18:35"], ["2594", "18:36"], ["2465", "18:45"]]
                                ] }

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

  context '#route_nums' do
    it 'returns an array of the route numbers' do
      expect(scraper.route_nums).to eq route_numbers
    end
  end

  context '#route_names' do
    it 'returns an array of route names' do
      expect(scraper.route_names.first).to eq 'Liberation Station - Gorey Pier'
    end
  end

  context '#timetable_pages' do
    it 'returns an array of Mechanize::Pages for each route timetable page' do
      expect(scraper.timetable_pages.all? { |e| e.class == Mechanize::Page}).to eq true
    end
  end

  context '#titles' do
    it 'returns an array of timetable titles for the given route index' do
      expect(scraper.titles(0)).to eq titles
    end
  end

  context '#bounds' do
    it 'returns an array of "Inbound" or "Outbound" for each timetable for the given route index' do
      expect(scraper.bounds(0)).to eq route_1_bounds
    end

    it 'correctly identifies routes with all Outbound journeys' do
      expect(scraper.bounds(15)).to eq route_15_bounds
    end
  end

  context '#days' do
    it 'returns an array of days for each timetable for the given route index' do
      expect(scraper.days(0)).to eq route_1_days
    end
  end

  context '#header_trs' do
    it 'returns a 2D array of headers table rows for each timetable for the given route index' do
      expect(scraper.header_trs(6).map &:count).to eq [52, 35, 40, 27] # no Sunday service for route 4
    end
  end

  context '#bus_nums' do
    it 'returns a 2D array of the number of buses in each timetable for a given route index' do
      expect(scraper.bus_nums(16)).to eq [15, 12]
    end
  end

  context '#times_trs' do
    it 'returns the times tables for the given timetable' do
      expect(scraper.times_trs(6).map &:count).to eq [52, 35, 40, 27] # no Sunday service for route 4
    end
  end

  context '#stop_times' do
    it 'returns an array of stop codes and times for a given route index, timetable index and column index' do
      expect(scraper.stop_times(16, 1, 0)).to eq stop_times
    end
  end

  context '#special_day' do
    it 'returns nil if the given route, timetable have no special days, for any column' do
      expect(scraper.special_day(16, 0, 0)).to be_nil
    end

    it 'returns the special day if the given route, timetable and column index is special' do
      expect(scraper.special_day(16, 0, 1)).to eq 'School Days Only'
    end

    it 'returns the special day if the given route, timetable and column index is special for routes which have special days in more than 1 timetable' do
      expect(scraper.special_day(8, 0, 14)).to eq 'Fridays Only'
    end
  end

  context '#buses' do
    it 'returns a 3D array of bus data for a given route index' do
      expect(scraper.buses(16)[1].last).to eq bus_19_last_on_saturday
    end
  end

end
