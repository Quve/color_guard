module ColorGuard
  module Store
    def self.build(configuration)
      return Noop.new if configuration.store.nil?

      store_name, *config = configuration.store
      store_type = self.const_get(store_name.to_s.split("-").map!(&:capitalize).join)

      store_type.new(*config)
    end

    autoload :Cookie, "color_guard/store/cookie"
    autoload :Noop, "color_guard/store/noop"
    autoload :Stack, "color_guard/store/stack"
    autoload :UrlParameter, "color_guard/store/url_parameter"
  end
end
