require 'azure_generic_resource'

class AzureDataFactoryDataSet < AzureGenericResource
  name 'azure_data_factory_dataset'
  desc 'Verifies settings for an Azure DataSet'
  example <<-EXAMPLE
     describe azure_data_factory_dataset(resource_group: 'example',factory_name: 'factory_name', dataset_name: 'ds-name') do
       it { should exists }
     end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.DataFactory/factories', opts)
    opts[:required_parameters] = %i(factory_name)
    opts[:resource_path] = [opts[:factory_name], 'datasets'].join('/')
    opts[:resource_identifiers] = %i(dataset_name)
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureDataFactoryDataSet)
  end
end
