require "azure_generic_resource"

class AzureVirtualNetworkGatewayConnection < AzureGenericResource
  name "azure_virtual_network_gateway_connection"
  desc "Verifies settings for an Azure Virtual Network Gateway Connection"
  example <<-EXAMPLE
    describe azure_virtual_network_gateway_connection(resource_group: 'inspec-rg', name: 'nw-gw-connection') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)
    opts[:resource_provider] = specific_resource_constraint("Microsoft.Network/connections", opts)

    super(opts, true)
    create_resource_methods(@resource_long_desc[:properties])
  end

  def to_s
    super(AzureVirtualNetworkGateway)
  end
end
