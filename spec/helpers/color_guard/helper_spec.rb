require "spec_helper"

RSpec.describe ColorGuard::Helper do
  subject{ Object.new.extend(ColorGuard::Helper) }

  describe "#feature_active?" do
    it "returns true if ColorGuard#active? returns true" do
      allow(ColorGuard).to receive(:active?).and_return(true)
      expect(subject.feature_active?(:anything, 99)).to eq(true)
    end

    it "returns false if ColorGuard#active? returns false" do
      allow(ColorGuard).to receive(:active?).and_return(false)
      expect(subject.feature_active?(:anything_else, 97)).to eq(false)
    end

    context "if #current_user is a defined method" do
      before do
        def subject.current_user
          13317
        end
      end

      it "passes the current user to ColorGuard#active?" do
        expect(ColorGuard).to receive(:active?).with(:feature, 13317)
        subject.feature_active?(:feature)
      end
    end
  end
end
