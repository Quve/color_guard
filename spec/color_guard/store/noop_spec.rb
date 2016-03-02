require "color_guard"

RSpec.describe ColorGuard::Store::Noop do
  describe "#find" do
    it "returns nil" do
      expect(subject.find("anything")).to eq(nil)
    end
  end

  describe "write!" do
    it "returns false" do
      expect(subject.write!(Object.new)).to eq(false)
    end
  end
end
