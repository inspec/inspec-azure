require 'azure_generic_resources'

class AzureManagementGroups < AzureGenericResources
  name 'azure_management_groups'
  desc 'Verifies settings for an Azure Management Groups'
  example <<-EXAMPLE
    describe azure_management_groups do
      its('names') { should include 'example-group' }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Management/managementGroups', opts)
    opts[:resource_uri] = "providers/#{opts[:resource_provider]}"
    opts[:add_subscription_id] = false

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
    table_schema = [
      { column: :names, field: :name },
      { column: :ids, field: :id },
      { column: :types, field: :type },
      { column: :properties, field: :properties },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureManagementGroups)
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
        id: resource_instance&.id,
        name: resource_instance&.name,
        properties: resource_instance&.properties,
        type: resource_instance&.type,
      }
    end
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermManagementGroups < AzureManagementGroups
  name 'azurerm_management_groups'
  desc 'Verifies settings for an Azure Management Groups'
  example <<-EXAMPLE
    describe azurerm_management_groups do
      its('names') { should include 'example-group' }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureManagementGroups.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2018-03-01-preview'
    super
  end
end
