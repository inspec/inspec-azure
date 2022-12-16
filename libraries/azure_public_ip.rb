require "azure_generic_resource"

class AzurePublicIp < AzureGenericResource
  name "azure_public_ip"
  desc "Verifies settings for public IP address"
  example <<-EXAMPLE
    describe azure_public_ip(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.Network/publicIPAddresses", opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzurePublicIp)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermPublicIp < AzurePublicIp
  name "azurerm_public_ip"
  desc "Verifies settings for public IP address"
  example <<-EXAMPLE
    describe azurerm_public_ip(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzurePublicIp.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= "2020-05-01"
    super
  end
end
