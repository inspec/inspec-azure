require 'azure_generic_resources'

class AzureMonitorLogProfiles < AzureGenericResources
  name 'azure_monitor_log_profiles'
  desc 'Fetches all Azure Monitor Log Profiles'
  example <<-EXAMPLE
    describe azure_monitor_log_profiles do
      its('names') { should include('default') }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Insights/logProfiles', opts)
    # See azure_policy_definition for more info on the usage of `resource_uri` parameter.
    opts[:resource_uri] = '/providers/Microsoft.Insights/logProfiles'
    opts[:add_subscription_id] = true

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    table_schema = [
      { column: :names, field: :name },
      { column: :ids, field: :id },
      { column: :properties, field: :properties },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureMonitorLogProfiles)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermMonitorLogProfiles < AzureMonitorLogProfiles
  name 'azurerm_monitor_log_profiles'
  desc 'Fetches all Azure Monitor Log Profiles'
  example <<-EXAMPLE
    describe azurerm_monitor_log_profiles do
      its('names') { should include('default') }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureMonitorLogProfiles.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2016-03-01'
    super
  end
end
