require "color_guard"

RSpec.describe ColorGuard::Store::Cookie do
  subject{ ColorGuard::Store::Cookie.new(cookies) }
  let(:cookies) do
    {
      "other" => "something",
      "color_guard.feature" => "true",
      "color_guard.false_feature" => "false"
    }
  end

  describe "#find" do
    it "stores features only for cookies matching the prefix" do
      expect(subject.find("feature")).not_to be_nil
      expect(subject.find("false_feature")).not_to be_nil
      expect(subject.find("other")).to be_nil
    end

    it "returns a feature with 0 percent if the cookie is false" do
      feature = subject.find("false_feature")
      expect(feature.percentage).to eq(0)
    end

    it "returns a feature with 100 percent if the cookie is not false" do
      feature = subject.find("feature")
      expect(feature.percentage).to eq(100)
    end
  end

  describe "#write!" do
    it "returns false" do
      expect(subject.write!(Object.new)).to eq(false)
    end
  end
end
