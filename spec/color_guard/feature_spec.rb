require "color_guard"

RSpec.describe ColorGuard::Feature do
  subject{ ColorGuard::Feature.new("test_feature", "10|1") }

  describe "#initialize" do
    context "when no serialized representation is provided" do
      subject{ ColorGuard::Feature.new("new_feature") }

      it "sets the percentage to zero" do
        expect(subject.percentage).to eq(0)
      end

      it "sets the users to empty" do
        expect(subject.users).to eq([])
      end

      it "sets the feature name" do
        expect(subject.name).to eq("new_feature")
      end
    end

    context "when a serialized representation is provided" do
      subject{ ColorGuard::Feature.new("test", "73|1,2,5") }

      it "sets the feature name" do
        expect(subject.name).to eq("test")
      end

      it "sets the percentage" do
        expect(subject.percentage).to eq(73)
      end

      it "sets the users" do
        expect(subject.users).to eq(["1", "2", "5"])
      end
    end
  end

  describe "#serialize" do
    it "returns a serialized version of the feature" do
      expect(subject.serialize).to eq("10|1")
    end
  end

  describe "#add_user" do
    it "adds the user to the users list" do
      subject.add_user(101)
      expect(subject.users).to include("101")
    end
  end

  describe "#remove_user" do
    it "removes the user from the users list" do
      subject.remove_user(1)
      expect(subject.users).to be_empty
    end
  end

  describe "#clear" do
    it "emptys the user list" do
      subject.clear
      expect(subject.users).to be_empty
    end

    it "zeros the percentage" do
      subject.clear
      expect(subject.percentage).to eq(0)
    end
  end

  describe "#active?" do
    it "returns true if the user is in the percentage" do
      subject.percentage = 99
      expect(subject.active?(1)).to eq(true)
    end

    it "returns true if the user is in the active users" do
      subject.add_user(101)
      expect(subject.active?(101)).to eq(true)
    end

    it "returns true if there is no user and the percentage is 100" do
      subject.percentage = 100
      expect(subject.active?(nil)).to eq(true)
    end

    it "returns false if there is no user and the percentage is < 100" do
      subject.percentage = 99
      expect(subject.active?(nil)).to eq(false)
    end
  end
end
