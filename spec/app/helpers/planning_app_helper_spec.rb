describe PlanningAppHelper do

  before do
    class PlanningAppHelperClass
      include PlanningAppHelper
    end
    @h = PlanningAppHelperClass.new
  end

  let(:p_app) { build(:planning_app) }
  let(:stringy?) { Proc.new { |e| e.class == String } }
  string = Faker::Lorem.paragraph
  let(:lines) { 4 }
  let(:div_string) {
    "<div style='height:68px; overflow:scroll'>#{string}</div>"
  }

  context '#fix_height_div_wrap' do
    it "should wrap provided string in a fixed-height, scrollable div" do
      expect(@h.fix_height_div_wrap(string, 4)).to eq(div_string)
    end
  end

  context '#div_wrap_strings_in' do
    it 'should wrap every string in a fixed-height div' do
      values = p_app.to_hash.values
      strings = values.select &stringy?
      wrapped = strings.map { |s| @h.fix_height_div_wrap(s, 4) }
      expect(@h.div_wrap_strings_in(values, 4).select &stringy?).to eq(wrapped)
    end

    it 'should leave non-strings untouched' do
      values = p_app.to_hash.values
      non_str = values.reject &stringy?
      expect(@h.div_wrap_strings_in(values, 4).reject &stringy?).to eq(non_str)
    end
  end

end
