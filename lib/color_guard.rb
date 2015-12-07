require "color_guard/engine"
require "rollout"

module ColorGuard
  mattr_accessor :store, instance_accessor: false

  class << self
    delegate :active?, :activate_group, :define_group, :deactivate_group, :activate_user,
             :deactivate_user, :activate_percentage, :deactivate_percentage, :deactivate, :activate,
             to: :rollout

    def features
      rollout.features.map{ |f| ColorGuard::Feature.new(rollout.get(f)) }
    end

    def all_features_enabled?
      ENV['COLOR_GUARD_ENABLE_ALL'].present?
    end

    private

    # For now we are just providing a thin wrapper around rollout. The point of this
    # library is partially to allow us to swap this out/extend it in the future
    def rollout
      $rollout ||= begin
        return NullRollout.new if all_features_enabled?

        raise "ColorGuard.store must be set" if store.nil?
        Rollout.new(store, randomize_percentage: true)
      end
    end
  end

  class NullRollout
    def active?(*args); true; end

    def activate_group(*args); end
    def define_group(*args); end
    def deactivate_group(*args); end
    def activate_user(*args); end
    def deactivate_user(*args); end
    def activate_percentage(*args); end
    def deactivate_percentage(*args); end
    def deactivate(*args); end
    def activate(*args); end
  end
end
