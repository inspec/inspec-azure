require 'azure_generic_resources'

class AzureHPCCaches < AzureGenericResources
  name 'azure_hpc_caches'
  desc 'Verifies settings for a collection of Azure HPC Caches.'
  example <<-EXAMPLE
    describe azure_hpc_caches do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.StorageCache/caches', opts)
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureHPCCaches)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:properties])
    end
  end
end
