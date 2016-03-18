require "color_guard"

RSpec.describe ColorGuard do
  let(:current_config) { double(ColorGuard::Configuration) }
  let(:feature) { double(ColorGuard::Feature, :"percentage=" => true) }
  let(:store) { double(ColorGuard::Store, find: feature, write!: true) }

  before{ ColorGuard.configuration = current_config }
  after { ColorGuard.configuration = nil }

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

  describe ".active?" do
    before { allow(ColorGuard).to receive(:store).and_return(store) }

    it "returns true if the feature is active" do
      allow(feature).to receive(:active?).and_return true
      expect(ColorGuard.active?(:some_feature)).to eq(true)
    end

    it "returns false if the feature is no active" do
      allow(feature).to receive(:active?).and_return false
      expect(ColorGuard.active?(:feature_x)).to eq(false)
    end
  end

  describe ".activate!" do
    before { allow(ColorGuard).to receive(:store).and_return(store)  }

    it "finds the appropriate feature" do
      expect(store).to receive(:find).with(:some_feature)
      ColorGuard.activate! :some_feature
    end

    it "sets the feature percentage to 100" do
      expect(feature).to receive(:percentage=).with(100)
      ColorGuard.activate! :feature
    end

    it "writes the feature to the store" do
      expect(store).to receive(:write!).with(feature)
      ColorGuard.activate! :feature
    end
  end

  describe ".deactivate!" do
    before { allow(ColorGuard).to receive(:store).and_return(store)  }

    it "finds the appropriate feature" do
      expect(store).to receive(:find).with(:some_feature)
      ColorGuard.deactivate! :some_feature
    end

    it "sets the feature percentage to 0" do
      expect(feature).to receive(:percentage=).with(0)
      ColorGuard.deactivate! :feature
    end

    it "writes the feature to the store" do
      expect(store).to receive(:write!).with(feature)
      ColorGuard.deactivate! :feature
    end
  end
end
