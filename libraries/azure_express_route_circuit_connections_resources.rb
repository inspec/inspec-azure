require 'azure_generic_resources'

class AzureExpressRouteCircuitConnectionsResources < AzureGenericResources
  name 'azure_express_route_circuit_connections_resources'
  desc 'ExpressRoute circuits connect your on-premises infrastructure to Microsoft through a connectivity provider'
  example <<-EXAMPLE
    describe azure_express_route_circuit_connections_resources(resource_group: 'rg', circuit_name: 'cn', peering_name: 'pn') do
      it{ should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format listing the all resources for a given subscription:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/
    #  providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/connections?api-version=2021-02-01
    #
    #
    # The dynamic part that has to be created for this resource:
    #   Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/connections?api-version=2021-02-01
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
    #   resource_provider => Microsoft.Network/expressRouteCircuits
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #
    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/expressRouteCircuits', opts)
    opts[:required_parameters] = %i(circuit_name peering_name)
    opts[:resource_path] = [opts[:circuit_name], 'peerings', opts[:peering_name], 'connections'].join('/')

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
      { column: :ids, field: :id },
      { column: :names, field: :name },
      { column: :locations, field: :location },
      { column: :types, field: :type },
      { column: :tags, field: :tags },
      { column: :provisioning_states, field: :provisioning_state },
      { column: :circuit_connection_status, field: :circuit_connection_status },
      { column: :ipv6_circuit_connection_config_status, field: :ipv6_circuit_connection_config_status },
      { column: :properties, field: :properties },
    ]
    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureExpressRouteCircuitConnectionsResources)
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
        location: resource[:location],
        type: resource[:type],
        tags: resource[:tags],
        provisioning_state: resource[:properties][:provisioningState],
        circuit_connection_status: resource[:properties][:circuitConnectionStatus],
        ipv6_circuit_connection_config_status: resource[:properties][:ipv6CircuitConnectionConfig][:circuitConnectionStatus],
        properties: resource[:properties],
      }
    end
  end
end
