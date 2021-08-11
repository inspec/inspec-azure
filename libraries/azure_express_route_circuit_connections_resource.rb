require 'azure_generic_resource'

class AzureExpressRouteCircuitConnectionsResource < AzureGenericResource
  name 'azure_express_route_circuit_connections_resource'
  desc 'ExpressRoute circuit connect your on-premises infrastructure to Microsoft through a connectivity provider'
  example <<-EXAMPLE
    describe azure_express_route_circuit_connections_resource(resource_group: 'example', circuit_name: 'cn', peering_name: 'pn', connection_name: 'cn') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/
    #   providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/
    #   connections/{connectionName}?api-version=2021-02-01
    #
    # The dynamic part that has to be created in this resource:
    #   Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/
    #   connections/{connectionName}?api-version=2021-02-01
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #
    # User supplied parameters:
    #   - resource_group => Required parameter unless `resource_id` is provided. {resourceGroupName}
    #   - name => Required parameter unless `resource_id` is provided. ExpressRouteCircuit name. {vmName}
    #   - resource_id => Optional parameter. If exists, `resource_group` and `name` must not be provided.
    #     In the following format:
    #       /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/
    #       providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}/
    #       connections/{connectionName}
    #   - api_version => Optional parameter. The latest version will be used unless provided. api-version
    #
    #   **`resource_group` and (resource) `name` or `resource_id`  will be validated in the backend appropriately.
    #     We don't have to do anything here.
    #
    # Following resource parameters have to be defined here.
    #   - resource_provider => Microsoft.Network/expressRouteCircuits
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #
    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/expressRouteCircuits', opts)
    opts[:required_parameters] = %i(circuit_name peering_name)
    opts[:resource_path] = [opts[:circuit_name], 'peerings', opts[:peering_name], 'connections'].join('/')
    opts[:resource_identifiers] = %i(connection_name)
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureExpressRouteCircuitConnectionsResource)
  end

  def provisioning_state
    properties.provisioningState if exists?
  end

  def circuit_connection_status
    properties.circuitConnectionStatus if exists?
  end

  def ipv6_circuit_connection_config_status
    properties.ipv6CircuitConnectionConfig.circuitConnectionStatus
  end
end
