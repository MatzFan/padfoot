describe PlanningAppHelper do
  before do
    # helper class
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
end
