module ColorGuard
  module Store
    class Stack
      attr_reader :stores

      def initialize(config = {})
        @stores = []
        @cache = {}
      end

      def push(store)
        @stores.unshift store
      end

      # Searches down each store in the stack until it finds the feature its looking for
      def find(feature_name)
        cache(feature_name) do
          @stores.lazy.map{ |store| store.find(feature_name) }.select{ |f| !f.nil? }.first
        end
      end

      def all
        @stores.map { |store| store.all }
      end

      # Attempts to write to each store in the stack until one of the writes is successful
      def write!(feature)
        # Remove any cached version of the feature but don't repopulate the cache in case
        # one of the stores in the chain manipulates the result in some way
        @cache.delete(feature.name)

        !!@stores.find{ |store| store.write!(feature) }
      end

      private

      def cache(name)
        return @cache[name] if @cache[name]

        result = yield
        @cache[name] = result
        result
      end
    end
  end
end
