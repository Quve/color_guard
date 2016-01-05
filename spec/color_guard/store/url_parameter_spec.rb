require "color_guard"

RSpec.describe ColorGuard::Store::UrlParameter do
  subject{ ColorGuard::Store::UrlParameter.new(query_string) }
  let(:query_string) { "other=something&color_guard_feature=true&color_guard_false_feature=false" }

  describe "#find" do
    it "stores features only for parameters matching the prefix" do
      expect(subject.find("feature")).not_to be_nil
      expect(subject.find("false_feature")).not_to be_nil
      expect(subject.find("other")).to be_nil
    end

    it "returns a feature with 0 percent if the parameter is false" do
      feature = subject.find("false_feature")
      expect(feature.percentage).to eq(0)
    end

    it "returns a feature with 100 percent if the parameter is not false" do
      feature = subject.find("feature")
      expect(feature.percentage).to eq(100)
    end
  end

  describe "write!" do
    it "returns false" do
      expect(subject.write!(Object.new)).to eq(false)
    end
  end
end
