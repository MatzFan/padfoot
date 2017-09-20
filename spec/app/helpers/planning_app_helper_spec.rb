describe PlanningAppHelper do
  before do
    # including class
    class PlanningAppHelperClass
      include PlanningAppHelper
    end
    @h = PlanningAppHelperClass.new
  end

  let(:p_app) { build(:planning_app) }
  let(:stringy?) { proc { |e| e.class == String } }
  string = Faker::Lorem.paragraph
  let(:lines) { 4 }
  let(:div_string) { "<div>#{string}</div>" }

  context '#apps_ordered(refs)' do
    it 'should return a list of PlanningApps in descending order by :order' do
      create(:planning_app, app_ref: 'P/2234/2017')
      create(:planning_app, app_ref: 'A/1234/2017')
      create(:planning_app, app_ref: 'RC/3234/2017')
      refs = %w[P/2234/2017 X/1275/2018 A/1234/2017]
      expect(@h.apps_ordered(refs).map(&:app_ref)).to eq ['P/2234/2017', 'A/1234/2017']
    end
  end

  context '#div_wrap' do
    it 'should wrap provided string in a <div>' do
      expect(@h.div_wrap(string)).to eq(div_string)
    end

    it 'should add a class if provided' do
      expect(@h.div_wrap(string, 'a-class')).to include("class = 'a-class'")
    end
  end

  context '#div_wrap_strings_in' do
    it 'should wrap every string in a <div>' do
      values = p_app.to_hash.values
      strings = values.select(&stringy?)
      wrapped = strings.map { |s| @h.div_wrap(s) }
      expect(@h.div_wrap_strings_in(values).select(&stringy?)).to eq(wrapped)
    end

    it 'should leave non-strings untouched' do
      values = p_app.to_hash.values
      non_str = values.reject(&stringy?)
      expect(@h.div_wrap_strings_in(values).reject(&stringy?)).to eq(non_str)
    end
  end

  context '#geolocate_location(address)' do
    it 'should find call #results_for on a GazetteerFinder object' do
      allow_any_instance_of(GazetteerFinder).to receive(:results_for).with('ad')
      expect(-> { @h.geolocate_location('ad') }).not_to raise_error
    end
  end
end
