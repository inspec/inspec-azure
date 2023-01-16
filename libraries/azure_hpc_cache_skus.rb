require "azure_generic_resources"

class AzureHPCCacheSKUs < AzureGenericResources
  name "azure_hpc_cache_skus"
  desc "Verifies settings for a collection of Azure HPC Storage SKUs"
  example <<-EXAMPLE
    describe azure_hpc_cache_skus do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.StorageCache/skus", opts)
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureHPCCacheSKUs)
  end
end
