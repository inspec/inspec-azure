require "azure_generic_resources"

class AzureRoleDefinitions < AzureGenericResources
  name "azure_role_definitions"
  desc "Verifies settings for a collection of Azure Roles"
  example <<-EXAMPLE
    describe azure_role_definitions do
      its('names') { should include('role') }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.Authorization/roleDefinitions", opts)
    # See azure_policy_definitions resource for how to use `resource_uri` and `add_subscription_id` parameters.
    opts[:resource_uri] = "providers/#{opts[:resource_provider]}"
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
      { column: :types, field: :type },
      { column: :role_names, field: :role_name },
      { column: :properties, field: :properties },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureRoleDefinitions)
  end

  private

  # This is for backward compatibility.
  def populate_table
    return [] if @resources.empty?
    @resources.each do |resource|
      resource_instance = AzureResourceProbe.new(resource)
      dm = AzureResourceDynamicMethods.new
      dm.create_methods(resource_instance, resource[:properties])
      @table << {
        id: resource[:id],
        name: resource[:name],
        properties: resource_instance&.properties,
        type: resource_instance&.properties&.type,
        role_name: resource_instance&.properties&.roleName,
      }
    end
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermRoleDefinitions < AzureRoleDefinitions
  name "azurerm_role_definitions"
  desc "Verifies settings for a collection of Azure Roles"
  example <<-EXAMPLE
    describe azurerm_role_definitions do
      its('names') { should include('role') }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureRoleDefinitions.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= "2015-07-01"
    super
  end
end
