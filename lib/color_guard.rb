module ColorGuard
  autoload :Configuration, "color_guard/configuration"

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end
end
