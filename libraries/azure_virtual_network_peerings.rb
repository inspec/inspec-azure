require 'azure_generic_resources'

class AzureVirtualNetworkPeerings < AzureGenericResources
  name 'azure_virtual_network_peerings'
  desc 'Verifies settings for Azure Virtual Network Peerings.'
  example <<-EXAMPLE
    describe azure_virtual_network_peerings(resource_group: 'RESOURCE_GROUP_NAME', vnet: 'VIRTUAL_NETWORK_NAME') do
      it{ should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format listing all virtual Network Peerings in a virtual network:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #   Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings?api-version=2020-05-01
    #
    # The dynamic part that has to be created for this resource:
    #   Microsoft.Network/virtualNetworks/{virtualNetworkName}/virtualNetworkPeerings?api-version=2020-05-01
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #
    # For parameters applicable to all resources, see project's README.
    #
    # User supplied parameters:
    #   - resource_group => Required parameter unless `resource_id` is provided. {resourceGroupName}
    #   - vnet => Required parameter unless `resource_id` is provided. Virtual network name. {virtualNetworkName}
    #       It has to be defined as a required parameter.
    #       opts[:required_parameters] = %i(vnet)
    #   - api_version => Optional parameter. The latest version will be used unless provided. api-version
    #
    #   **`resource_group` will be added into the URL appropriately in the backend.
    #     We don't have to do anything here except making it mandatory (required) parameter.
    #
    # Following resource parameters have to be defined/created here.
    #   resource_provider => Microsoft.Network/virtualNetworks
    #   resource_path => {virtualNetworkName}/virtualNetworkPeerings
    #
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/virtualNetworks', opts)
    opts[:required_parameters] = %i(resource_group vnet)
    # Unless provided here, a generic display name will be created in the backend.
    opts[:display_name] = "Virtual Network Peerings for #{opts[:vnet]} Virtual Network"
    opts[:resource_path] = [opts[:vnet], 'virtualNetworkPeerings'].join('/')

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
    table_schema = [
      { column: :names, field: :name },
      { column: :etags, field: :etag },
      { column: :ids, field: :id },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureVirtualNetworkPeerings)
  end
end
