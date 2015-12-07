require 'spec_helper'

RSpec.describe ColorGuard do
  let(:rollout) { double("Backend") }

  before { allow(ColorGuard).to receive(:rollout).and_return(rollout) }
  after  { allow(ColorGuard).to receive(:rollout).and_call_original }

  it "delegates '#active?' to the rollout backend if all_features_enabled? is false" do
    expect(rollout).to receive(:active?).with(:feature)
    subject.active?(:feature)
  end

  it "does not delegate '#active?' to the rollout backend if all_features_enabled? is true" do
    expect(rollout).to receive(:active?).with(:feature)
    subject.active?(:feature)
  end

  it "returns true if all features are enabled" do
    allow(ColorGuard).to receive(:rollout).and_return(ColorGuard::NullRollout.new)
    expect(subject.active?(:feature)).to eq(true)
  end

  it "delegates '#activate_group' to the rollout backend" do
    expect(rollout).to receive(:activate_group).with(:feature, :group)
    subject.activate_group(:feature, :group)
  end

  it "delegates '#define_group' to the rollout backend" do
    expect(rollout).to receive(:define_group).with(:group)
    subject.define_group(:group)
  end

  it "delegates '#deactivate_group' to the rollout backend" do
    expect(rollout).to receive(:deactivate_group).with(:feature, :group)
    subject.deactivate_group(:feature, :group)
  end

  it "delegates '#activate_user' to the rollout backend" do
    expect(rollout).to receive(:activate_user).with(:feature, 13)
    subject.activate_user(:feature, 13)
  end

  it "delegates '#deactivate_user' to the rollout backend" do
    expect(rollout).to receive(:deactivate_user).with(:feature, 10)
    subject.deactivate_user(:feature, 10)
  end

  it "delegates '#activate_percentage' to the rollout backend" do
    expect(rollout).to receive(:activate_percentage).with(:feature, 50)
    subject.activate_percentage(:feature, 50)
  end

  it "delegates '#deactivate_percentage' to the rollout backend" do
    expect(rollout).to receive(:deactivate_percentage).with(:feature)
    subject.deactivate_percentage(:feature)
  end

  it "delegates '#deactivate' to the rollout backend" do
    expect(rollout).to receive(:deactivate).with(:feature)
    subject.deactivate(:feature)
  end

  it "delegates '#activate' to the rollout backend" do
    expect(rollout).to receive(:activate).with(:feature)
    subject.activate(:feature)
  end

  describe "#features" do
    context "for each feature in rollout" do
      before do
        allow(rollout).to receive(:features).and_return([:one, :two, :three])
        allow(rollout).to receive(:get){ |name| stub_rollout_feature(name) }
      end

      it "loads the rollout feature and wraps it in a color guard feature" do
        expect(subject.features.map{ |f| f.name }).to eq([:one, :two, :three])
      end
    end
  end

  describe "#all_features_enabled?" do
    it "returns true if the 'COLOR_GUARD_ENABLE_ALL' environment variable is set" do
      ENV['COLOR_GUARD_ENABLE_ALL'] = "true"
      expect(subject.all_features_enabled?).to eq(true)
    end

    it "returns false if the 'COLOR_GUARD_ENABLE_ALL' environment variable is not set" do
      ENV['COLOR_GUARD_ENABLE_ALL'] = nil
      expect(subject.all_features_enabled?).to eq(false)
    end
  end

  def stub_rollout_feature(name)
    double("Rollout Feature: #{name}", name: name, percentage: 27, users: [], groups: [])
  end
end
