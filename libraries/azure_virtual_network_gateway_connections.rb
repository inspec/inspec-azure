require 'azure_generic_resources'

class AzureVirtualNetworkGatewayConnections < AzureGenericResources
  name 'azure_virtual_network_gateway_connections'
  desc 'Verifies settings for Azure Virtual Network Gateway Connections'
  example <<-EXAMPLE
    describe azure_virtual_network_gateway_connections(resource_group: 'inspec-rg') do
      it { should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/connections', opts)
    super(opts, true)

    return if failed_resource?
    populate_filter_table_from_response
  end

  def to_s
    super(AzureVirtualNetworkGatewayConnections)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:properties])
    end
  end
end
