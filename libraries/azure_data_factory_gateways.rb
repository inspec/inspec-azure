require 'azure_generic_resources'

class AzureDataFactoryGateways < AzureGenericResources
  name 'azure_data_factory_gateways'
  desc 'List azure gateway unr ta factory.'
  example <<-EXAMPLE
     describe azure_data_factory_gateways(resource_group: 'example', factory_name: 'fn') do
       it { should exist }
     end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    # Azure REST API endpoint URL format for the resource:
    #   https://management.azure.com/subscriptions/{SubscriptionID}/resourcegroups/{ResourceGroupName}/
    #   providers/Microsoft.DataFactory/datafactories/{DataFactoryName}/gateways/{GatewayName}?api-version={api-version}
    opts[:resource_provider] = specific_resource_constraint('Microsoft.DataFactory/datafactories', opts)
    opts[:required_parameters] = %i(factory_name)
    opts[:resource_path] = [opts[:factory_name], 'gateways'].join('/')
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
      { column: :ids, field: :id },
      { column: :properties, field: :properties },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureDataFactoryGateway)
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
        properties: resource[:properties],
      }
    end
  end
end
