require 'azure_generic_resource'

class AzureNetworkInterface < AzureGenericResource
  name 'azure_network_interface'
  desc 'Verifies settings for an Azure Network Interface'
  example <<-EXAMPLE
    describe azure_network_interface(resource_group: 'rg-1', name: 'my-nic-name') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/networkInterfaces', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def private_ip
    return unless exists?
    properties&.ipConfigurations&.first&.properties&.privateIPAddress
  end

  def public_ip
    return unless exists?
    properties&.ipConfigurations&.first&.properties&.privateIPAddress
  end

  def has_private_address_ip?
    return unless exists?
    !properties&.ipConfigurations&.first&.properties&.privateIPAddress&.to_s&.empty?
  end

  def has_public_address_ip?
    return unless exists?
    !properties&.ipConfigurations&.first&.properties&.publicIPAddress&.to_s&.empty?
  end

  def ip_configurations
    return unless exists?
    properties&.ipConfigurations
  end

  def primary?
    return unless exists?
    properties&.primary
  end

  def to_s
    super(AzureNetworkInterface)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermNetworkInterface < AzureNetworkInterface
  name 'azurerm_network_interface'
  desc 'Verifies settings for an Azure Network Interface'
  example <<-EXAMPLE
    describe azurerm_network_interface(resource_group: 'rg-1', name: 'my-nic-name') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureNetworkInterface.name)
    super
  end
end
