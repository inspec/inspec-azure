require 'azure_generic_resources'

class AzureVirtualMachineDisks < AzureGenericResources
  name 'azure_virtual_machine_disks'
  desc 'Verifies settings for a collection of Azure VM Disks.'
  example <<-EXAMPLE
    describe azure_virtual_machine_disks do
      it { should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Compute/disks', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of superclass methods or API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    #   - column: It is defined as an instance method, callable on the resource, and present `field` values in a list.
    #   - field: It has to be identical with the `key` names in @table items that will be presented in the FilterTable.
    table_schema = [
      { column: :attached, field: :attached },
      { column: :resource_group, field: :resource_group },
      { column: :names, field: :name },
      { column: :properties, field: :properties },
      { column: :locations, field: :location },
      { column: :ids, field: :id },
      { column: :tags, field: :tags },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureVirtualMachineDisks)
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
    return [] if @resources.empty?
    @resources.each do |resource|
      attached_c = resource[:properties][:diskState].eql?('Attached')
      resource_group_c, _provider, _r_type = Helpers.res_group_provider_type_from_uri(resource[:id])

      @table << {
        id: resource[:id],
        name: resource[:name],
        properties: resource[:properties],
        attached: attached_c,
        resource_group: resource_group_c,
        locations: resource[:location],
        tags: resource[:tags],
      }
    end
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermVirtualMachineDisks < AzureVirtualMachineDisks
  name 'azurerm_virtual_machine_disks'
  desc 'Verifies settings for a collection of Azure VM Disks'
  example <<-EXAMPLE
    describe azurerm_virtual_machine_disks do
        it  { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureVirtualMachineDisks.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2017-03-30'
    super
  end
end
