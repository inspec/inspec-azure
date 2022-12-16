require "azure_generic_resources"

class AzureSecurityCenterPolicies < AzureGenericResources
  name "azure_security_center_policies"
  desc "Verifies settings for Security Center"
  example <<-EXAMPLE
    describe azure_security_center_policies do
      its('policy_names') { should include('default') }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    opts[:resource_provider] = "Microsoft.Security/policies"

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    table_schema = [
      { column: :policy_names, field: :name },
      { column: :ids, field: :id },
      { column: :properties, field: :properties },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureSecurityCenterPolicies)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermSecurityCenterPolicies < AzureSecurityCenterPolicies
  name "azurerm_security_center_policies"
  desc "Verifies settings for Security Center"
  example <<-EXAMPLE
    describe azurerm_security_center_policies do
      its('policy_names') { should include('default') }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureSecurityCenterPolicies.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= "2015-06-01-Preview"
    super
  end
end
