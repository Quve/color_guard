class ColorGuard::Feature
  attr_reader :rollout_feature

  delegate :name, :percentage, :groups, :users, to: :rollout_feature

  def initialize(rollout_feature)
    @rollout_feature = rollout_feature
  end
end
