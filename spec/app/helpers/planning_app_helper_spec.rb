describe PlanningAppHelper do

  before do
    class PlanningAppHelperClass
      include PlanningAppHelper
    end
    @app_helper = PlanningAppHelperClass.new
  end
  string = Faker::Lorem.paragraph
  let(:lines) { 4 }
  let(:div_string) {
    "<div style='height:68px; overflow:scroll'>#{string}</div>"
  }

  context '#fixed_height_div_wrap' do
    it "should wrap provided string in a fixed-height, scrollable div" do
      expect(@app_helper.fixed_height_div_wrap(string, 4)).to eq(div_string)
    end
  end

end
