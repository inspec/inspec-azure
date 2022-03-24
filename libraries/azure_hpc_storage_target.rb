require 'azure_generic_resource'

class AzureHPCStorageTarget < AzureGenericResource
  name 'azure_hpc_storage_target'
  desc 'Retrieves and verifies the settings of an Azure HPC Storage Target'
  example <<-EXAMPLE
    describe azure_hpc_storage_target(resource_group: 'inspec-rg', cache_name: 'sc1', name: 'st1') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.StorageCache/caches', opts)
    opts[:resource_identifiers] = [:cache_name]
    opts[:resource_path] = [opts[:cache_name], 'storageTargets', opts[:name]].join('/')
    super(opts, true)
  end

  def to_s
    super(AzureHPCStorageTarget)
  end
end
