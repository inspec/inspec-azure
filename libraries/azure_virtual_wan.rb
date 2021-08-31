require 'azure_generic_resource'

class AzureVirtualWan < AzureGenericResource
  name 'azure_virtual_wan'
  desc 'Retrieves and verifies a Azure Virtual WAN in a Resource Group'
  example <<-EXAMPLE
    describe azure_virtual_wan(resource_group: 'inspec-default', name: 'webservice-wan') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/virtualWans', opts)
    super(opts, true)
  end

  def to_s
    super(AzureVirtualWan)
  end
end
