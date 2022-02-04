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
    ip_configurations&.select { |conf| conf.properties.primary == true }
        &.first&.properties&.privateIPAddress
  end

  def private_ip_address_list
    return unless exists?
    ip_configurations&.collect { |conf| conf.properties.privateIPAddress }
  end

  def public_ip_id_list
    return unless exists?
    ip_configurations&.collect { |conf| conf.properties.publicIPAddress.id }
  end

  def public_ip
    return unless exists?
    ip_configurations&.select { |conf| conf.properties.primary == true }
        &.first&.properties&.publicIPAddress&.id
  end

  def has_private_address_ip?
    return unless exists?
    !private_ip_address_list.empty?
  end

  def has_public_address_ip?
    return unless exists?
    !public_ip_id_list.empty?
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
