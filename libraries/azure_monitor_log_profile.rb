require 'azure_generic_resource'

class AzureMonitorLogProfile < AzureGenericResource
  name 'azure_monitor_log_profile'
  desc 'Verifies settings for a Azure Monitor Log Profile'
  example <<-EXAMPLE
    describe azure_monitor_log_profile(name: 'default') do
      it { should exist }
      its('retention_enabled') { should be true }
      its('retention_days')    { should eq(365) }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Insights/logProfiles', opts)
    # See azure_policy_definition for more info on the usage of `resource_uri` parameter.
    opts[:resource_uri] = '/providers/microsoft.insights/logprofiles/'
    opts[:add_subscription_id] = true
    opts[:display_name] = "#{opts[:name]} Log Profile"

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureMonitorLogProfile)
  end

  def has_log_retention_enabled?
    return unless exists?
    !!retention_enabled
  end

  def retention_policy
    return unless exists?
    properties&.retentionPolicy
  end

  def retention_days
    return unless exists?
    properties&.retentionPolicy&.days
  end

  def retention_enabled
    return unless exists?
    properties&.retentionPolicy&.enabled
  end

  def storage_account
    return unless exists?
    sa = properties.storageAccountId
    resource_group, _provider, _r_type = Helpers.res_group_provider_type_from_uri(sa)
    { name: sa.split('/').last, resource_group: resource_group }
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermMonitorLogProfile < AzureMonitorLogProfile
  name 'azurerm_monitor_log_profile'
  desc 'Verifies settings for a Azure Monitor Log Profile'
  example <<-EXAMPLE
    describe azurerm_monitor_log_profile(name: 'default') do
      it { should exist }
      its('retention_enabled') { should be true }
      its('retention_days')    { should eq(365) }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureMonitorLogProfile.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2016-03-01'
    super
  end
end
