require "color_guard"

RSpec.describe ColorGuard do
  let(:current_config) { double(ColorGuard::Configuration) }
  before{ ColorGuard.configuration = current_config }

  describe ".configuration" do
    it "creates a configuration if there isn't one" do
      ColorGuard.configuration = nil
      expect(ColorGuard.configuration).to be_a ColorGuard::Configuration
    end

    it "returns the current configuration if there is one set" do
      expect(ColorGuard.configuration).to eq(current_config)
    end
  end

  describe ".configure" do
    it "yields the current configuration" do
      ColorGuard.configure do |config|
        expect(config).to eq(current_config)
      end
    end
  end
end
