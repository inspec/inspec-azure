require 'azure_generic_resource'

class AzureDataFactoryPipelineRunResource < AzureGenericResource
  name 'azure_data_factory_pipeline_run_resource'
  desc 'Verifies settings for an Azure DataSet'
  example <<-EXAMPLE
      describe azure_data_factory_pipeline_run_resource(resource_group: 'example',factory_name: 'factory_name', run_id: 'run_id') do
        it { should exists }
      end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.DataFactory/factories', opts)
    opts[:required_parameters] = %i(factory_name)
    opts[:resource_path] = [opts[:factory_name], 'pipelineruns'].join('/')
    opts[:resource_identifiers] = %i(run_id)
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureDataFactoryPipelineRunResource)
  end
end
