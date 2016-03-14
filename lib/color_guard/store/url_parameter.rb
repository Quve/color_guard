module ColorGuard
  module Store
    class UrlParameter
      def initialize(query_string)
        @values = read_values(query_string)
      end

      def find(feature_name)
        @values[feature_name.to_sym]
      end

      def write!(feature)
        false
      end

      def all
        @values
      end

      private

      def read_values(query_string)
        query_string.split('&').inject({}) do |values, param_string|
          key, value = param_string.split('=')
          if key.match(/^color_guard_(.+)$/)
            flag_name = $1
            values[flag_name.to_sym] = feature(flag_name, value)
          end
          values
        end || {}
      end

      def feature(name, value)
        f = Feature.new(name)
        f.percentage = value == "false" ? 0 : 100
        f
      end
    end
  end
end
