# frozen_string_literal: true

require 'support/azure/response_struct'

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

    EXEMPTED_TAGS = %i(
      tags
    ).freeze
    private_constant :EXEMPTED_TAGS

    def with_cache(cache)
      @cache = cache
    end

    def with_client(client, override: false)
      set_reader(:rest_client, client, override)
    end

    def for_tenant(tenant_id, override: false)
      set_reader(:tenant_id, tenant_id, override)
    end

    def for_subscription(subscription_id, override: false)
      set_reader(:subscription_id, subscription_id, override)
    end

    # Converts data (a hash) into a struct. This is a recursive
    # call that will wall the entire hash and convert all key/value pairs.
    #
    # If data is a single value it will be returned.
    # If data is an array then each value in the array will be converted to a struct.
    # If data is an empty hash then it will return the empty array.
    # If data is an array of hashes then each value will be converted to a struct.
    def to_struct(data)
      return data.map { |v| to_struct(v) } if data.is_a?(Array)
      return data unless data.is_a?(Hash)
      return data if data.empty?

      exempted = slice!(data, EXEMPTED_TAGS)

      ResponseStruct.create(data.keys.map(&:to_sym) + exempted.keys.map(&:to_sym),
                            data.values.map { |v| to_struct(v) } + exempted.values)
    end

    private

    attr_reader :required_attrs

    def slice!(data, keys)
      selected = data.select { |k, _| keys.include?(k.to_sym) }
      data.reject! { |k, _| keys.include?(k.to_sym) }
      selected
    end

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

    def get(url:, api_version:, error_handler: nil, unwrap: nil)
      confirm_configured!

      cache.fetch(url) do
        body = rest_client.get(url,
                               params: { 'api-version' => api_version },
                               headers: { Accept: 'application/json' }).body

        error_handler&.(body)

        if unwrap.respond_to?(:call)
          to_struct(unwrap.call(body, api_version))
        else
          to_struct(body.fetch('value', body))
        end
      end
    end
  end
end
