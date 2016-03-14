require "redis"
require "connection_pool"

module ColorGuard
  module Store
    class Redis
      attr_reader :options

      def initialize(options = {})
        @options = options
      end

      def find(feature_name)
        connection_pool.with do |redis|
          Feature.new(feature_name, redis.get(feature_name))
        end
      end

      def all
        features = {}
        connection_pool.with do |redis|
          keys = redis.keys
          keys.each do |key|
            features[key.to_sym] = redis.get(key)
          end
        end
        features
      end

      def write!(feature)
        connection_pool.with do |redis|
          redis.set(feature.name, feature.serialize)
        end
      end

      private

      def connection_pool
        @@connection_pool ||= begin
                                timeout = options[:pool_timeout] || 1
                                size    = options[:pool_size] || 1

                                ConnectionPool.new(timeout: timeout, size: size) do
                                  build_client
                                end
                              end
      end

      def build_client
        namespace = options[:namespace]

        client = ::Redis.new(options)
        if namespace
          begin
            require "redis/namespace"
            ::Redis::Namespace.new(namespace, redis: client)
          rescue LoadError => e
            $stderr.puts "redis-namespace must be installed to use a namespace with Color Guard"
            raise e
          end
        end
      end
    end
  end
end
