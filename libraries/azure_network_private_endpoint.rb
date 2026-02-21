require 'azure_generic_resource'

class AzureNetworkPrivateEndpoint < AzureGenericResource
  name 'azure_network_private_endpoint'
  desc 'Verifies settings for an Azure Network Private Endpoint'
  example <<-EXAMPLE
    describe azure_network_private_endpoint(resource_group: "RESOURCE_GROUP", name: "private-endpoint-name") do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/privateEndpoints', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def subnet_id
    return unless exists?
    properties&.subnet&.id
  end

  def network_interface_ids
    return unless exists?
    properties&.networkInterfaces&.map(&:id)
  end

  def private_link_service_connection_ids
    return unless exists?
    properties&.privateLinkServiceConnections
      &.map { |conn| conn.properties&.privateLinkServiceId }
      &.compact
  end

  def manual_private_link_service_connection_ids
    return unless exists?
    properties&.manualPrivateLinkServiceConnections
      &.map { |conn| conn.properties&.privateLinkServiceId }
      &.compact
  end

  def to_s
    super(AzureNetworkPrivateEndpoint)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermNetworkPrivateEndpoint < AzureNetworkPrivateEndpoint
  name 'azurerm_network_private_endpoint'
  desc 'Verifies settings for an Azure Network Private Endpoint'
  example <<-EXAMPLE
    describe azurerm_network_private_endpoint(resource_group: "RESOURCE_GROUP", name: "private-endpoint-name") do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureNetworkPrivateEndpoint.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2020-05-01'

    super
  end
end
