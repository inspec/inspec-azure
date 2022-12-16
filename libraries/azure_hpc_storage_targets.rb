require "azure_generic_resources"

class AzureHPCStorageTargets < AzureGenericResources
  name "azure_hpc_storage_targets"
  desc "Verifies settings for a collection of Azure HPC Storage Targets"
  example <<-EXAMPLE
    describe azure_hpc_storage_targets(resource_group: 'inspec-rg', cache_name: 'sc1') do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.StorageCache/caches", opts)
    opts[:required_parameters] = %i(resource_group cache_name)
    opts[:resource_path] = [opts[:cache_name], "storageTargets"].join("/")
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureHPCStorageTargets)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:properties])
    end
  end
end
