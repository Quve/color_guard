require "color_guard"
require "rack"

module ColorGuard
  class Middleware
    attr_reader :config

    def initialize(app, config = {})
      @app = app
      @config = config
    end

    def call(env)
      Thread.current[:color_guard_store] = store(Rack::Request.new(env))
      response = @app.call(env)
      Thread.current[:color_guard_store] = nil

      response
    end

    private

    def store(request)
      if with_params? || with_cookies?
        store = Store::Stack.new
        store.push(Store.build(ColorGuard.configuration))
        store.push(Store::Cookie.new(request.cookies)) if config[:allow_cookies]
        store.push(Store::UrlParameter.new(request.query_string)) if config[:allow_url]
        store
      else
        Store.build(ColorGuard.configuration)
      end
    end

    def with_params?
      !!config[:allow_cookies]
    end

    def with_cookies?
      !!config[:allow_url]
    end
  end
end
