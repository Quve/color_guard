module ColorGuard
  module Store
    class Noop
      def find(feature_name)
        nil
      end

      def write!(feature)
        false
      end
    end
  end
end
