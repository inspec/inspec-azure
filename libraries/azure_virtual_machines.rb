require 'azure_generic_resources'

class AzureVirtualMachines < AzureGenericResources
  name 'azure_virtual_machines'
  desc 'Verifies settings for Azure Virtual Machines'
  example <<-EXAMPLE
    azure_virtual_machines(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    # raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format listing the all resources for a given subscription:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/providers/
    #   Microsoft.Compute/virtualMachines?api-version=2019-12-01
    #
    # or in a resource group only
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #   Microsoft.Compute/virtualMachines?api-version=2019-12-01
    #
    # The dynamic part that has to be created for this resource:
    #   Microsoft.Compute/virtualMachines?api-version=2019-12-01
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #
    # For parameters applicable to all resources, see project's README.
    #
    # User supplied parameters:
    #   - resource_group => Optional parameter.
    #   - api_version => Optional parameter. The latest version will be used unless provided.
    #
    #   **`resource_group`  will be used in the backend appropriately.
    #     We don't have to do anything here.
    #
    # Following resource parameters have to be defined/created here.
    #   resource_provider => Microsoft.Compute/virtualMachines
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #
    opts[:resource_provider] = specific_resource_constraint('Microsoft.Compute/virtualMachines', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of superclass methods or API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    #   - column: It is defined as an instance method, callable on the resource, and present `field` values in a list.
    #   - field: It has to be identical with the `key` names in @table items that will be presented in the FilterTable.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
    table_schema = [
      { column: :os_disks, field: :os_disk },
      { column: :data_disks, field: :data_disks },
      { column: :vm_names, field: :name },
      { column: :platforms, field: :platform },
      { column: :ids, field: :id },
      { column: :tags, field: :tags },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureVirtualMachines)
  end

  private

  # Populate the @table with the resource attributes.
  # @table has been declared in the super class as an empty array.
  # Each item in the @table
  #   - should be a Hash object
  #   - should have the exact key names defined in the @table_schema as `field`.
  def populate_table
    # If @resources empty than @table should stay as an empty array as declared in superclass.
    # This will ensure constructing resource and passing `should_not exist` test.
    return if @resources.empty?
    @resources.each do |resource|
      os_profile = resource[:properties][:osProfile]
      platform = \
        if os_profile.key?(:windowsConfiguration)
          'windows'
        elsif os_profile.key?(:linuxConfiguration)
          'linux'
        else
          'unknown'
        end
      @table << {
        id: resource[:id],
        os_disk: resource[:properties][:storageProfile][:osDisk][:name],
        data_disks: resource[:properties][:storageProfile][:dataDisks].map { |dd| dd[:name] unless dd.nil? },
        name: resource[:name],
        platform: platform,
        tags: resource[:tags],
      }
    end
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermVirtualMachines < AzureVirtualMachines
  name 'azurerm_virtual_machines'
  desc 'Verifies settings for Azure Virtual Machines'
  example <<-EXAMPLE
    azurerm_virtual_machines(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureVirtualMachines.name)
    super
  end
end
