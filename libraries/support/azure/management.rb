# frozen_string_literal: true

require 'singleton'

module Azure
  class Management
    include Singleton
    include Service

    def initialize
      @required_attrs = %i(rest_client subscription_id)
      @page_link_name = 'nextLink'
    end

    def activity_log_alert(resource_group, id)
      get(
        url: link(location: 'Microsoft.Insights/activityLogAlerts',
                  resource_group: resource_group) + id,
        api_version: '2017-04-01',
      )
    end

    def activity_log_alerts
      get(
        url: link(location: 'Microsoft.Insights/activityLogAlerts'),
        api_version: '2017-04-01',
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
  end
end
