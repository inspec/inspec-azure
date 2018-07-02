# frozen_string_literal: true

require 'json'
require 'singleton'

module Azure
  class Management
    include Singleton

    class Cache
      def initialize
        @store = {}
      end

      def fetch(key)
        @store.fetch(key) { @store[key] = yield }
      end
    end

    DEFAULT_MANAGEMENT_DEFINITION_FILE = './management.yaml'

    attr_reader :cache

    def initialize
      @cache = Cache.new

      parse_management_api_definition(
        ENV.fetch('MANAGEMENT_DEFINITION_FILE') {
          DEFAULT_MANAGEMENT_DEFINITION_FILE
        },
      )
    end

    def with_cache(cache)
      @cache = cache
    end

    def with_client(azure_client, override: false)
      set_reader(:azure_client, azure_client, override)
    end

    def for_subscription(subscription_id, override: false)
      set_reader(:subscription_id, subscription_id, override)
    end

    private

    def parse_management_api_definition(mgmt_def_file)
      ManagementMethodGenerator.generate(mgmt_def_file).map do |method|
        self.class.send(:define_method, method[:name], method[:body])
      end
    end

    def subscription_id
      'subid'
    end

    def link(location:, resource_group: nil)
      "/subscriptions/#{subscription_id}" \
      "#{"/resourceGroups/#{resource_group}" if resource_group}" \
      "/#{location}/"
    end

    def get(url:, api_version:)
      confirm_configured!

      cache.fetch(url) do
        body = azure_client.get(url, params: { 'api-version' => api_version }).body
        body.fetch('value', body)
      end
    end

    def confirm_configured!
      %i(azure_client subscription_id).each do |name|
        next if respond_to?(name)

        raise "Set #{name} before making requests"
      end
    end

    def set_reader(name, value, override)
      return self if respond_to?(name) && !override

      define_singleton_method(name) { value }

      self
    end
  end
end
