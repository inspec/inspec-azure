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

    attr_reader :cache

    def initialize
      @cache = Cache.new
    end

    def with_cache(cache)
      @cache = cache
    end

    def with_client(rest_client, override: false)
      set_reader(:rest_client, rest_client, override)
    end

    def for_subscription(subscription_id, override: false)
      set_reader(:subscription_id, subscription_id, override)
    end

    def activity_log_alert(resource_group, id)
      get(
        url: link(location: 'Microsoft.Insights/activityLogAlerts',
                  resource_group: resource_group) + id,
        api_version: '2016-04-01',
      )
    end

    def activity_log_alerts
      get(
        url: link(location: 'Microsoft.Insights/activityLogAlerts'),
        api_version: '2016-04-01',
      )
    end

    def log_profile(id)
      get(
        url: link(location: 'Microsoft.Insights/logProfiles') + id,
        api_version: '2016-03-01',
      )
    end

    def log_profiles
      get(
        url: link(location: 'Microsoft.Insights/logProfiles'),
        api_version: '2016-03-01',
      )
    end

    def network_security_group(resource_group, id)
      get(
        url: link(location: 'Microsoft.Network/networkSecurityGroups',
                  resource_group: resource_group) + id,
        api_version: '2018-02-01',
      )
    end

    def network_security_groups(resource_group)
      get(
        url: link(location: 'Microsoft.Network/networkSecurityGroups',
                  resource_group: resource_group),
        api_version: '2018-02-01',
      )
    end

    def network_watcher(resource_group, id)
      get(
        url: link(location: 'Microsoft.Network/networkWatchers',
                  resource_group: resource_group) + id,
        api_version: '2018-02-01',
      )
    end

    def network_watchers(resource_group)
      get(
        url: link(location: 'Microsoft.Network/networkWatchers',
                  resource_group: resource_group),
        api_version: '2018-02-01',
      )
    end

    def resource_groups
      get(url: link(location: 'resourcegroups', provider: false), api_version: '2018-02-01')
    end

    def security_center_policy(id)
      get(
        url: link(location: 'Microsoft.Security/policies') + id,
        api_version: '2015-06-01-Preview',
      )
    end

    def security_center_policies
      get(
        url: link(location: 'Microsoft.Security/policies'),
        api_version: '2015-06-01-Preview',
      )
    end

    def storage_accounts
      get(
        url: link(location: 'Microsoft.Storage/storageAccounts'),
        api_version: '2017-06-01',
      )
    end

    def virtual_machine(resource_group, id)
      get(
        url: link(location: 'Microsoft.Compute/virtualMachines',
                  resource_group: resource_group) + id,
        api_version: '2017-12-01',
      )
    end

    def virtual_machines(resource_group)
      get(
        url: link(location: 'Microsoft.Compute/virtualMachines',
                  resource_group: resource_group),
        api_version: '2017-12-01',
      )
    end

    def virtual_machine_disk(resource_group, id)
      get(
        url: link(location: 'Microsoft.Compute/disks',
                  resource_group: resource_group) + id,
        api_version: '2017-03-30',
      )
    end

    private

    def link(location:, provider: true, resource_group: nil)
      "/subscriptions/#{subscription_id}" \
      "#{"/resourceGroups/#{resource_group}" if resource_group}" \
      "#{'/providers' if provider}" \
      "/#{location}/"
    end

    def get(url:, api_version:)
      confirm_configured!

      cache.fetch(url) do
        body = rest_client.get(url, params: {'api-version' => api_version }).body
        body.fetch('value', body)
      end
    end

    def confirm_configured!
      %i(rest_client subscription_id).each do |name|
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
