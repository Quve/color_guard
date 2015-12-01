require "color_guard/engine"
require "rollout"

module ColorGuard
  mattr_accessor :store, instance_accessor: false

  class << self
    delegate :active?, :activate_group, :define_group, :deactivate_group, :activate_user,
             :deactivate_user, :activate_percentage, :deactivate_percentage, :deactivate, :activate,
             to: :rollout

    private

    # For now we are just providing a thin wrapper around rollout. The point of this
    # library is partially to allow us to swap this out/extend it in the future
    def rollout
      $rollout ||= begin
        raise "ColorGuard.store must be set" if store.nil?
        Rollout.new(store)
      end
    end
  end
end
