module ColorGuard
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def active?(feature_name, user = nil)
      feature = store.find(feature_name)
      feature && feature.active?(user)
    end

    def activate!(feature_name)
      store.find(feature_name).tap do |feature|
        feature.percentage = 100
        store.write!(feature)
      end
    end

    def deactivate!(feature_name)
      store.find(feature_name).tap do |feature|
        feature.percentage = 0
        store.write!(feature)
      end
    end

    def store
      Thread.current[:color_guard_store] ||= Store.build(configuration)
    end
  end

  autoload :Configuration, "color_guard/configuration"
  autoload :Store, "color_guard/store"
  autoload :Feature, "color_guard/feature"
end
