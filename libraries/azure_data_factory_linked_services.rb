require 'azure_generic_resources'

class AzureDataFactoryLinkedServices < AzureGenericResources
  name 'azure_data_factory_linked_services'
  desc 'Lists all azure linked services.'
  example <<-EXAMPLE
    describe azure_data_factory_linked_services(resource_group: 'RESOURCE_GROUP_NAME', factory_name: 'FACTORY_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/
    #   providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices?api-version=2018-06-01
    #
    opts[:resource_provider] = specific_resource_constraint('Microsoft.DataFactory/factories', opts)
    opts[:required_parameters] = %i(factory_name)
    opts[:resource_path] = [opts[:factory_name], 'linkedservices'].join('/')
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
      { column: :names, field: :name },
      { column: :types, field: :type },
      { column: :ids, field: :id },
      { column: :etags, field: :etag },
      { column: :type_properties, field: :type_properties },
      { column: :linked_service_types, field: :linked_service_type },
      { column: :properties, field: :properties },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureDataFactoryLinkedServices)
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
      @table << {
        id: resource[:id],
        name: resource[:name],
        type: resource[:type],
        etag: resource[:etag],
        type_properties: resource[:properties][:typeProperties],
        linked_service_type: resource[:properties][:type],
        properties: resource[:properties],
      }
    end
  end
end
