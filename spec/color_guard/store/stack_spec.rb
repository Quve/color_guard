require "color_guard"

RSpec.describe ColorGuard::Store::Stack do
  let(:first_store) { double("Store", find: nil, write!: false) }
  let(:second_store) { double("Another Store", find: nil, write!: false) }
  let(:feature) { double(ColorGuard::Feature, name: "a_feature") }

  subject do
    stack = ColorGuard::Store::Stack.new
    stack.push(second_store)
    stack.push(first_store)
    stack
  end

  describe "#find" do
    it "checks the first store" do
      expect(first_store).to receive(:find).with(:a_feature)
      subject.find(:a_feature)
    end

    context "when the feature is in a store" do
      before{ allow(first_store).to receive(:find).and_return(feature) }

      it "doesn't check the next store" do
        expect(second_store).not_to receive(:find)
        subject.find(:feature)
      end

      it "returns the feature" do
        expect(subject.find(:feature)).to eq(feature)
      end
    end

    context "when the feature is not in a store" do
      it "checks the next store" do
        expect(second_store).to receive(:find)
        subject.find(:feature)
      end
    end

    context "when the feature is not in any store" do
      it "returns nil" do
        expect(subject.find(:feature)).to be_nil
      end
    end
  end

  describe "write!" do
    it "calls write! on the first store" do
      expect(first_store).to receive(:write!).with(feature)
      subject.write!(feature)
    end

    context "when a store returns false" do
      it "calls write! on the next store" do
        expect(second_store).to receive(:write!).with(feature)
        subject.write!(feature)
      end
    end

    context "when a store returns true" do
      before { allow(first_store).to receive(:write!).and_return(true) }

      it "doesn't call write! on the next store" do
        expect(second_store).not_to receive(:write!)
        subject.write!(feature)
      end

      it "returns true" do
        expect(subject.write!(feature)).to eq(true)
      end
    end

    context "when all the stores return false" do
      it "returns false" do
        expect(subject.write!(feature)).to eq(false)
      end
    end
  end
end
