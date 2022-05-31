require 'azure_generic_resource'

class AzureHPCCache < AzureGenericResource
  name 'azure_hpc_cache'
  desc 'Retrieves and verifies the settings of an Azure HPC Cache.'
  example <<-EXAMPLE
    describe azure_hpc_cache(resource_group: 'inspec-rg', name: 'sc1') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.StorageCache/caches', opts)
    super(opts, true)
  end

  def to_s
    super(AzureHPCCache)
  end
end
