require 'azure_generic_resource'

class AzurePowerBiEmbeddedCapacity < AzureGenericResource
  name 'azure_power_bi_embedded_capacity'
  desc 'Retrieves and verifies the settings of an Azure Power BI Embedded Capacity.'
  example <<-EXAMPLE
    describe azure_power_bi_embedded_capacity(resource_group: 'inspec-azure-rg', name: 'power-bi-inspec') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.PowerBIDedicated/capacities', opts)
    super(opts, true)
  end

  def to_s
    super(AzurePowerBiEmbeddedCapacity)
  end
end
