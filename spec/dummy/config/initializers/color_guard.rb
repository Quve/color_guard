require 'color_guard'

# This is really a fake installation just for supporting the test app
class MemoryKeyStore
  def initialize
    @entries = {}
  end

  def get(key)
    @entries[key]
  end

  def set(key, value)
    @entries[key] = value
    "OK"
  end
end

ColorGuard.store = MemoryKeyStore.new

# Since our features are stored in memory instead of in redis we need to add defaults.
# Otherwise there would be no way to set values. We'll start with everything off
[:rainbows, :unicorns, :bill_murray].each do |feature_name|
  ColorGuard.deactivate(feature_name)
end
