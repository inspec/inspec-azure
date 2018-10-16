# frozen_string_literal: true

require 'singleton'

module Azure
  class Management
    include Singleton
    include Service

    def initialize
      @required_attrs = %i(backend)
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

    def activity_log_alert_filtered(filter)
      get(
        url: link(location: "Microsoft.Insights/eventTypes/management/values/?$filter=#{filter}"),
        api_version: '2017-03-01-preview',
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

    def aks_cluster(resource_group, id)
      get(
        url: link(location: 'Microsoft.ContainerService/managedClusters',
                  resource_group: resource_group) + id,
        api_version: '2018-03-31',
      )
    end

    def aks_clusters(resource_group)
      get(
        url: link(location: 'Microsoft.ContainerService/managedClusters',
                  resource_group: resource_group),
        api_version: '2018-03-31',
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
      get(
        url: link(location: 'resourcegroups', provider: false),
        api_version: '2018-02-01',
      )
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

    def storage_account(resource_group, name)
      get(
        url: link(location: "Microsoft.Storage/storageAccounts/#{name}",
                  resource_group: resource_group),
        api_version: '2017-06-01',
      )
    end

    def storage_accounts(resource_group)
      get(
        url: link(location: 'Microsoft.Storage/storageAccounts',
                  resource_group: resource_group),
        api_version: '2017-06-01',
      )
    end

    def blob_container(resource_group, storage_account_name, blob_container_name)
      get(
        url: link(location: "Microsoft.Storage/storageAccounts/#{storage_account_name}/"\
                            "blobServices/default/containers/#{blob_container_name}",
                  resource_group: resource_group),
        api_version: '2018-07-01',
      )
    end

    def blob_containers(resource_group, storage_account_name)
      get(
        url: link(location: "Microsoft.Storage/storageAccounts/#{storage_account_name}/"\
                            'blobServices/default/containers/',
                  resource_group: resource_group),
        api_version: '2018-07-01',
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

    def virtual_network(resource_group, id)
      get(
        url: link(location: 'Microsoft.Network/virtualNetworks',
                  resource_group: resource_group) + id,
        api_version: '2018-02-01',
      )
    end

    def virtual_networks(resource_group)
      get(
        url: link(location: 'Microsoft.Network/virtualNetworks',
                  resource_group: resource_group),
        api_version: '2018-02-01',
      )
    end

    def virtual_machine_disk(resource_group, id)
      get(
        url: link(location: 'Microsoft.Compute/disks',
                  resource_group: resource_group) + id,
        api_version: '2017-03-30',
      )
    end

    def subnet(resource_group, vnet, name)
      get(
        url: link(location: "Microsoft.Network/virtualNetworks/#{vnet}/subnets",
                  resource_group: resource_group) + name,
        api_version: '2018-02-01',
      )
    end

    def subnets(resource_group, vnet)
      get(
        url: link(location: "Microsoft.Network/virtualNetworks/#{vnet}/subnets",
                  resource_group: resource_group),
        api_version: '2018-02-01',
      )
    end

    def sql_servers(resource_group)
      get(
        url: link(location: 'Microsoft.Sql/servers',
                  resource_group: resource_group),
        api_version: '2018-06-01-preview',
      )
    end

    def sql_server(resource_group, name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{name}",
                  resource_group: resource_group),
        api_version: '2018-06-01-preview',
      )
    end

    def sql_server_auditing_settings(resource_group, server_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/auditingSettings/default",
                  resource_group: resource_group),
        api_version: '2017-03-01-preview',
      )
    end

    def sql_server_threat_detection_settings(resource_group, server_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/securityAlertPolicies/Default",
                  resource_group: resource_group),
        api_version: '2017-03-01-preview',
      )
    end

    def sql_server_administrators(resource_group, server_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/administrators",
                  resource_group: resource_group),
        api_version: '2014-04-01',
      )
    end

    def sql_server_firewall_rules(resource_group, server_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/firewallRules",
                  resource_group: resource_group),
        api_version: '2014-04-01',
      )
    end

    def sql_database(resource_group, server_name, database_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/databases/#{database_name}",
                  resource_group: resource_group),
        api_version: '2017-10-01-preview',
      )
    end

    def sql_databases(resource_group, server_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/databases",
                  resource_group: resource_group),
        api_version: '2017-10-01-preview',
      )
    end

    def sql_database_auditing_settings(resource_group, server_name, database_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/databases/#{database_name}" \
                            '/auditingSettings/default',
                  resource_group: resource_group),
        api_version: '2017-03-01-preview',
      )
    end

    def sql_database_threat_detection_settings(resource_group, server_name, database_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/databases/#{database_name}" \
                            '/securityAlertPolicies/default',
                  resource_group: resource_group),
        api_version: '2014-04-01',
      )
    end

    def sql_database_encryption(resource_group, server_name, database_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/databases/#{database_name}" \
                            '/transparentDataEncryption/current',
                  resource_group: resource_group),
        api_version: '2014-04-01',
      )
    end

    def key_vaults(resource_group)
      get(
        url: link(location: 'Microsoft.KeyVault/vaults',
                  resource_group: resource_group),
        api_version: '2016-10-01',
      )
    end

    def key_vault(resource_group, key_vault_name)
      get(
        url: link(location: "Microsoft.KeyVault/vaults/#{key_vault_name}",
                  resource_group: resource_group),
        api_version: '2016-10-01',
      )
    end

    def key_vault_diagnostic_settings(key_vault_id)
      get(
        url: "#{key_vault_id}/providers/microsoft.insights/diagnosticSettings",
        api_version: '2017-05-01-preview',
      )
    end

    private

    def rest_client
      backend.enable_cache(:api_call)
      @rest_client ||= Azure::Rest.new(backend.azure_client)
    end

    def link(location:, provider: true, resource_group: nil)
      "/subscriptions/#{subscription_id}" \
      "#{"/resourceGroups/#{resource_group}" if resource_group}" \
      "#{'/providers' if provider}" \
      "/#{location}/"
    end
  end
end
