# frozen_string_literal: true

module Azure
  module Service
    class Cache
      def initialize
        @store = {}
      end

      def fetch(key)
        @store.fetch(key) { @store[key] = yield }
      end
    end

    def with_cache(cache)
      @cache = cache
    end

    def with_client(graph_client, override: false)
      set_reader(:rest_client, graph_client, override)
    end

    def for_tenant(tenant_id, override: false)
      set_reader(:tenant_id, tenant_id, override)
    end

    def for_subscription(subscription_id, override: false)
      set_reader(:subscription_id, subscription_id, override)
    end

    private

    attr_reader :required_attrs

    def cache
      @cache ||= Cache.new
    end

    def confirm_configured!
      required_attrs.each do |name|
        next if respond_to?(name)

        raise "Set #{name} before making requests"
      end
    end

    def set_reader(name, value, override)
      return self if respond_to?(name) && !override

      define_singleton_method(name) { value }

      self
    end

    def get(url:, api_version:)
      confirm_configured!

      cache.fetch(url) do
        body = rest_client.get(url, params: { 'api-version' => api_version }).body
        structify(body.fetch('value', body))
      end
    end

    def structify(value)
      return value.map { |v| structify(v) } if value.is_a?(Array)
      return value unless value.is_a?(Hash)

      Struct.new(*value.keys.map(&:to_sym)) do
        def key?(key)
          members.include?(key)
        end

        alias_method :keys, :members
      end.new(*value.values)
    end
  end
end
