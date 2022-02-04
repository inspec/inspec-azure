require 'azure_generic_resource'

class AzureLoadBalancer < AzureGenericResource
  name 'azure_load_balancer'
  desc 'Verifies settings for an Azure Load Balancer'
  example <<-EXAMPLE
    describe azure_load_balancer(resource_group: 'rg-1', name: 'lb-1') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/loadBalancers', opts)
    opts[:resource_identifiers] = %i(loadbalancer_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.\
    super(opts, true)
  end

  def to_s
    super(AzureLoadBalancer)
  end
end
