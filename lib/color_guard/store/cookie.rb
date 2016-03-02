module ColorGuard
  module Store
    class Cookie
      def initialize(cookies)
        @values = read_values(cookies)
      end

      def find(feature_name)
        @values[feature_name.to_sym]
      end

      def write!(feature)
        false
      end

      private

      def read_values(cookies)
        cookies.inject({}) do |values, (key, value)|
          if key.match(/^color_guard\.(.+)$/)
            flag_name = $1
            values[flag_name.to_sym] = feature(flag_name, value)
          end
          values
        end || {}
      end

      def feature(name, cookie_value)
        f = Feature.new(name)
        f.percentage = cookie_value == "false" ? 0 : 100
        f
      end
    end
  end
end
