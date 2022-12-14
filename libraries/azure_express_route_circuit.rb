require "azure_generic_resource"

class AzureExpressRouteCircuit < AzureGenericResource
  name "azure_express_route_circuit"
  desc "ExpressRoute circuit connect your on-premises infrastructure to Microsoft through a connectivity provider"
  example <<-EXAMPLE
    describe azure_express_route_circuit(resource_group: 'example', circuit_name: 'circuitName') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/
    # providers/Microsoft.Network/expressRouteCircuits/{circuitName}?api-version=2020-11-01
    #
    # The dynamic part that has to be created in this resource:
    #   Microsoft.Network/expressRouteCircuits/{circuitName}?api-version=2019-12-01
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #
    # User supplied parameters:
    #   - resource_group => Required parameter unless `resource_id` is provided. {resourceGroupName}
    #   - name => Required parameter unless `resource_id` is provided. ExpressRouteCircuit name. {vmName}
    #   - resource_id => Optional parameter. If exists, `resource_group` and `name` must not be provided.
    #     In the following format:
    #       /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #       Microsoft.Network/expressRouteCircuits/{circuitName}
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
    opts[:resource_provider] = specific_resource_constraint("Microsoft.Network/expressRouteCircuits", opts)
    opts[:resource_identifiers] = %i(circuit_name)
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureExpressRouteCircuit)
  end

  def provisioning_state
    properties.provisioningState if exists?
  end

  def sku_name
    sku.name if exists?
  end

  def sku_tier
    sku.tier if exists?
  end

  def sku_family
    sku.family if exists?
  end

  def circuit_provisioning_state
    properties.circuitProvisioningState if exists?
  end

  def allow_classic_operations
    properties.allowClassicOperations if exists?
  end

  def gateway_manager_etag
    properties.gatewayManagerEtag if exists?
  end

  def allow_global_reach
    properties.allowGlobalReach if exists?
  end

  def global_reach_enabled
    properties.globalReachEnabled if exists?
  end

  def stag
    properties.stag if exists?
  end

  def service_key
    properties.serviceKey if exists?
  end

  def service_provider_properties_name
    properties.serviceProviderProperties.serviceProviderName if exists?
  end

  def service_provider_properties_peering_location
    properties.serviceProviderProperties.peeringLocation if exists?
  end

  def service_provider_properties_bandwidth_in_mbps
    properties.serviceProviderProperties.bandwidthInMbps if exists?
  end

  def service_provider_provisioning_state
    properties.serviceProviderProperties.provisioningState if exists?
  end
end
