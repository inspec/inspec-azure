require 'azure_generic_resource'

class AzureDataFactoryPipeline < AzureGenericResource
  name 'azure_data_factory_pipeline'
  desc 'Verifies settings for Azure data factory pipeline '
  example <<-EXAMPLE
      describe azure_data_factory_pipeline(resource_group: resource_group, factory_name: factory_name, pipeline_name: pipeline_name)  do
        it { should exist }
      end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    #
    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/
    #   providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}?api-version=2018-06-01
    #
    opts[:resource_provider] = specific_resource_constraint('Microsoft.DataFactory/factories', opts)
    opts[:required_parameters] = %i(factory_name)
    opts[:resource_path] = [opts[:factory_name], 'pipelines'].join('/')
    opts[:resource_identifiers] = %i(pipeline_name)
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureDataFactoryPipeline)
  end
end
