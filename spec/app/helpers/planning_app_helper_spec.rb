require 'spec_helper'

RSpec.describe "Padfoot::App::PlanningAppHelper" do
  pending "add some examples to (or delete) #{__FILE__}" do
    let(:helpers){ Class.new }
    before { helpers.extend Padfoot::App::PlanningAppHelper }
    subject { helpers }

    it "should return nil" do
      expect(subject.foo).to be_nil
    end
  end
end
