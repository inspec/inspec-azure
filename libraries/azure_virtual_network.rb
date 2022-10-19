require 'azure_generic_resource'

class AzureVirtualNetwork < AzureGenericResource
  name 'azure_virtual_network'
  desc 'Verifies settings for an Azure Virtual Network.'
  example <<-EXAMPLE
    describe azure_virtual_network(resource_group: 'RESOURCE_GROUP_NAME', name: 'VIRTUAL_NETWORK_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby error will be raised.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers
    #   /Microsoft.Network/virtualNetworks/{virtualNetworkName}?api-version=2020-05-01
    #
    # The dynamic part that has to be created in this resource:
    #   Microsoft.Network/virtualNetworks/{virtualNetworkName}?api-version=2020-05-01
    #
    # User supplied parameters:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #   - {resourceGroupName} => Required parameter. It must be provided by the user. (`resource_group`)
    #   - {virtualNetworkName} => Required parameter. It must be provided by the user. (`name`)
    #   - api-version => Optional parameter. The latest version will be used by the backend if not provided. (`api_version`)
    #
    #   **`resource_group` and (resource) `name` will be used appropriately in the backend.
    #     We don't have to do anything here except making them mandatory (required) parameters.
    #
    # Following resource parameters have to be defined/created here.
    #   resource_provider => Microsoft.Network/virtualNetworks
    #
    # Either the `resource_id` itself or the necessary parameters should be provided to the backend by calling `super(opts)`.
    resource_provider = 'Microsoft.Network/virtualNetworks'
    # if opts[:resource_id].nil?
    #   # The resource_id will be created in the backend with the provided parameters.
    #   #
    #   opts[:required_parameters] = %i(resource_group name)
    #
    #   opts[:resource_provider] = specific_resource_constraint(resource_provider, opts)
    # else
    #   raise ArgumentError, "Resource provider must be #{resource_provider}." \
    #     unless opts[:resource_id].include?(resource_provider)
    # end

    opts[:resource_provider] = specific_resource_constraint(resource_provider, opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureVirtualNetwork)
  end

  # Resource specific methods can be created.
  # `return unless exists?` is necessary to prevent any unforeseen Ruby error.
  # Following methods are created to provide the same functionality with the current resource pack >>>>
  # @see https://github.com/inspec/inspec-azure

  def address_space
    return unless exists?
    properties.addressSpace.addressPrefixes
  end

  def dns_servers
    return unless exists?
    properties.dhcpOptions.dnsServers
  end

  def vnet_peerings
    return unless exists?
    name_id = ->(peer) { [peer.name, peer.properties.remoteVirtualNetwork.id] }
    any_nils = ->(pair) { pair.any?(&:nil?) }

    properties.virtualNetworkPeerings.collect(&name_id).reject(&any_nils).to_h
  end

  def enable_ddos_protection
    return unless exists?
    properties.enableDdosProtection
  end

  def enable_vm_protection
    return unless exists?
    properties.enableVmProtection
  end

  def subnets
    return unless exists?
    subs = properties.subnets || []
    subs.collect(&:name)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermVirtualNetwork < AzureVirtualNetwork
  name 'azurerm_virtual_network'
  desc 'Verifies settings for an Azure Virtual Network'
  example <<-EXAMPLE
    describe azurerm_virtual_network(resource_group: 'example', name: 'vnet-name') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureVirtualNetwork.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2018-02-01'
    super
  end
end
