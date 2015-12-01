require 'spec_helper'

RSpec.describe ColorGuard do
  let(:rollout) { double("Backend") }

  before { allow(ColorGuard).to receive(:rollout).and_return(rollout) }
  after  { allow(ColorGuard).to receive(:rollout).and_call_original }

  it "delegates '#active?' to the rollout backend" do
    expect(rollout).to receive(:active?).with(:feature)
    subject.active?(:feature)
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
end
