require 'azure_generic_resource'

class AzurePublicIp < AzureGenericResource
  name 'azure_public_ip'
  desc 'Verifies settings for public IP address'
  example <<-EXAMPLE
    describe azure_public_ip(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/publicIPAddresses', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzurePublicIp)
  end
end
