# frozen_string_literal: true

require 'azurerm_monitor_activity_log_alert'

class AzureMonitorActivityLogAlert < AzurermMonitorActivityLogAlert
  name 'azure_monitor_activity_log_alert'
  desc '[DEPRECATED] Please use the azurerm_monitor_activity_log_alert resource'
  example <<-EXAMPLE
    describe azure_monitor_activity_log_alert(resource_group: 'example', name: 'AlertName') do
      it { should exist }
      its('operations') { should include 'Microsoft.Authorization/policyAssignments/write' }
    end
  EXAMPLE

  def initialize(resource_group: nil, name: nil)
    warn '[DEPRECATION] The `azure_monitor_activity_log_alert` resource is ' \
         'deprecated and will be removed in version 2.0. Use the ' \
         '`azurerm_monitor_activity_log_alert` resource instead.'
    super
  end
end

require 'azurerm_monitor_activity_log_alerts'

class AzureMonitorActivityLogAlerts < AzurermMonitorActivityLogAlerts
  name 'azure_monitor_activity_log_alerts'
  desc '[DEPRECATED] Please use the azurerm_monitor_activity_log_alerts resource'
  example <<-EXAMPLE
    describe azure_monitor_activity_log_alerts do
      its('names') { should include('example-log-alert') }
    end
  EXAMPLE

  def initialize
    warn '[DEPRECATION] The `azure_monitor_activity_log_alerts` resource is ' \
         'deprecated and will be removed in version 2.0. Use the ' \
         '`azurerm_monitor_activity_log_alerts` resource instead.'
    super
  end
end

require 'azurerm_monitor_log_profile'

class AzureMonitorLogProfile < AzurermMonitorLogProfile
  name 'azure_monitor_log_profile'
  desc '[DEPRECATED] Please uze azurerm_monitor_log_profile'
  example <<-EXAMPLE
    describe azure_monitor_log_profile(name: 'default') do
      it { should exist }
      its('retention_enabled') { should be true }
      its('retention_days')    { should eq(365) }
    end
  EXAMPLE

  def initialize(options = { name: 'default' })
    warn '[DEPRECATION] The `azure_monitor_log_profile` resource is ' \
         'deprecated and will be removed in version 2.0. Use the ' \
         '`azurerm_monitor_log_profile` resource instead.'
    super
  end
end

require 'azurerm_monitor_log_profiles'

class AzureMonitorLogProfiles < AzurermMonitorLogProfiles
  name 'azure_monitor_log_profiles'
  desc '[DEPRECATED] Please use azurerm_monitor_log_profiles'
  example <<-EXAMPLE
    describe azure_monitor_log_profiles do
      its('names') { should include('default') }
    end
  EXAMPLE

  def initialize
    warn '[DEPRECATION] The `azure_monitor_log_profiles` resource is ' \
         'deprecated and will be removed in version 2.0. Use the ' \
         '`azurerm_monitor_log_profiles` resource instead.'
    super
  end
end

require 'azurerm_network_security_group'

class AzureNetworkSecurityGroup < AzurermNetworkSecurityGroup
  name 'azure_network_security_group'
  desc 'Verifies settings for Network Security Groups'
  example <<-EXAMPLE
    describe azure_network_security_group(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(resource_group: nil, name: nil)
    warn '[DEPRECATION] The `azure_network_security_group` resource is ' \
         'deprecated and will be removed in version 2.0. Use the ' \
         '`azurerm_network_security_group` resource instead.'
    super
  end
end

require 'azurerm_network_security_groups'

class AzureNetworkSecurityGroups < AzurermNetworkSecurityGroups
  name 'azure_network_security_groups'
  desc '[DEPRECATED] Please use azurerm_network_security_groups'
  example <<-EXAMPLE
    azure_network_security_groups(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  def initialize(resource_group: nil)
    warn '[DEPRECATION] The `azure_network_security_groups` resource is ' \
         'deprecated and will be removed in version 2.0. Use the ' \
         '`azurerm_network_security_groups` resource instead.'
    super
  end
end

require 'azurerm_network_watcher'

class AzureNetworkWatcher < AzurermNetworkWatcher
  name 'azure_network_watcher'
  desc '[DEPRECATED] Please use azurerm_network_watcher'
  example <<-EXAMPLE
    describe azure_network_watcher(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(resource_group: nil, name: nil)
    warn '[DEPRECATION] The `azure_network_watcher` resource is deprecated ' \
         'will be removed in version 2.0. Use the `azurerm_network_watcher` ' \
         'resource instead.'
    super
  end
end

require 'azurerm_network_watchers'

class AzureNetworkWatchers < AzurermNetworkWatchers
  name 'azure_network_watchers'
  desc '[DEPRECATED] Please use azurerm_network_watchers'
  example <<-EXAMPLE
    azure_network_watchers(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  def initialize(resource_group:)
    warn '[DEPRECATION] The `azure_network_watchers` resource is deprecated ' \
         'and will be removed in version 2.0. Use the ' \
         '`azurerm_network_watchers` resource instead.'
    super
  end
end

require 'azurerm_resource_groups'

class AzureResourceGroups < AzurermResourceGroups
  name 'azure_resource_groups'
  desc '[DEPRECATED] Please use the azurerm_resource_groups resource'
  example <<-EXAMPLE
    describe azure_resource_groups do
      its('names') { should include('example-group') }
    end
  EXAMPLE

  def initialize
    warn '[DEPRECATION] The `azure_resource_groups` resource is deprecated ' \
         'and will be removed in version 2.0. Use the ' \
         '`azurerm_resource_groups` resource instead.'
    super
  end
end

require 'azurerm_security_center_policies'

class AzureSecurityCenterPolicies < AzurermSecurityCenterPolicies
  name 'azure_security_center_policies'
  desc '[DEPRECATED] Please use the azurerm_security_center_policies resource'
  example <<-EXAMPLE
    describe azure_security_center_policies do
      its('policy_names') { should include('default') }
    end
  EXAMPLE

  def initialize
    warn '[DEPRECATION] The `azure_security_center_policies` resource is ' \
         'deprecated and will be removed in version 2.0. Use the ' \
         '`azurerm_security_center_policies` resource instead.'
    super
  end
end

require 'azurerm_security_center_policy'

class AzureSecurityCenterPolicy < AzurermSecurityCenterPolicy
  name 'azure_security_center_policy'
  desc '[DEPRECATED] Please use the azurerm_security_center_policy resource'
  example <<-EXAMPLE
    describe azure_security_center_policy(name: 'default') do
      its('log_collection') { should eq('On') }
    end
  EXAMPLE

  def initialize(*args)
    warn '[DEPRECATION] The `azure_security_center_policy` resource is ' \
         'deprecated and will be removed in version 2.0. Use the ' \
         '`azurerm_security_center_policy` resource instead.'
    super
  end
end
