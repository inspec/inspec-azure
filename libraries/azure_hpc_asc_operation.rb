require 'azure_generic_resource'

class AzureHPCASCOperation < AzureGenericResource
  name 'azure_hpc_asc_operation'
  desc 'Retrieves and verifies the settings of an Azure HPC ASC Operation.'
  example <<-EXAMPLE
    describe azure_hpc_asc_operation(location: 'eastus', operation_id: 'OPERATION_ID') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.StorageCache/locations', opts)
    opts[:required_parameters] = %i(location operation_id)
    opts[:resource_path] = [opts[:location], 'ascOperations', opts[:operation_id]].join('/')
    super(opts, true)
  end

  def to_s
    super(AzureHPCASCOperations)
  end
end
