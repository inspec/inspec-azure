require 'azure_generic_resource'

class AzureSubnet < AzureGenericResource
  name 'azure_subnet'
  desc 'Verifies settings for an Azure Virtual Network Subnet.'
  example <<-EXAMPLE
    describe azure_subnet(resource_group: 'RESOURCE_GROUP_NAME', vnet: 'VIRTUAL_NETWORK_NAME' name: 'SUBNET_NAME') do
      it { should exist }
      its('name') { should eq 'SUBNET_NAME' }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #   Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}?api-version=2020-05-01
    #
    # The dynamic part that will be created in this resource:
    #   Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}?api-version=2020-05-01
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
    #   - name => Required parameter unless `resource_id` is provided. Subnet name. {subnetName}
    #   - resource_id => Optional parameter. If exists, other resource related parameters must not be provided.
    #     In the following format:
    #       /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #       Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}
    #   - api_version => Optional parameter. The latest version will be used unless provided. api-version
    #
    #   **`resource_group`, (resource) `name` and `resource_id`  will be validated in the backend appropriately.
    #     We don't have to do anything here.
    #
    # Following resource parameters have to be defined/created here.
    #   resource_provider => Microsoft.Network/virtualNetworks
    #   resource_path => {virtualNetworkName}/subnets
    #
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #
    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/virtualNetworks', opts)
    opts[:required_parameters] = %i(vnet)
    opts[:resource_path] = [opts[:vnet], 'subnets'].join('/')

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureSubnet)
  end

  # Resource specific methods can be created.
  # `return unless exists?` is necessary to prevent any unforeseen Ruby error.
  # Following methods are created to provide the same functionality with the current resource pack >>>>
  # @see https://github.com/inspec/inspec-azure

  def address_prefix
    return unless exists?
    properties.addressPrefix
  end

  def nsg
    return unless exists?
    return nil unless properties.respond_to?(:networkSecurityGroup)
    properties.networkSecurityGroup.id.split('/').last
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermSubnet < AzureSubnet
  name 'azurerm_subnet'
  desc 'Verifies settings for an Azure Virtual Network Subnet'
  example <<-EXAMPLE
    describe azurerm_subnet(resource_group: 'example',vnet: 'virtual-network-name' name: 'subnet-name') do
      it { should exist }
      its('name') { should eq 'subnet-name' }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureSubnet.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2018-02-01'
    super
  end
end
