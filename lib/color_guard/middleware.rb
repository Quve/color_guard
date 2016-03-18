require "color_guard"
require "rack"
require "erb"

module ColorGuard
  class Middleware
    attr_reader :config

    def initialize(app, config = {})
      @app = app
      @config = config
    end

    def call(env)
      @req = Rack::Request.new(env)
      Thread.current[:color_guard_store] = store(@req)

      if @req.path_info =~ /color_guard\/write_feature/
        write_feature
      elsif @req.path_info =~ /color_guard/
        flags_list
      else
        response = @app.call(env)
        Thread.current[:color_guard_store] = nil
        response
      end
    end

    private

    def flags_list
      @all_features = ColorGuard.all
      view = File.read(File.expand_path("../views/all_features.html.erb", __FILE__))
      body = ERB.new(view).result(binding).to_s
      ['200', { 'Content-Type' => 'text/html' }, [ body ] ]
    end

    def write_feature
      feature = Feature.new(@req.params["feature_name"])
      store(@req).write!(feature)
      flags_list
    end

    def store(request)
      if with_params? || with_cookies?
        store = Store::Stack.new
        store.push(Store.build(ColorGuard.configuration))
        store.push(Store::Cookie.new(request.cookies)) if with_cookies?
        store.push(Store::UrlParameter.new(request.query_string)) if with_params?
        store
      else
        Store.build(ColorGuard.configuration)
      end
    end

    def with_cookies?
      !!config[:allow_cookies]
    end

    def with_params?
      !!config[:allow_url]
    end
  end
end
