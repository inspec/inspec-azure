require 'azure_generic_resources'

class AzureDataFactoryPipelines < AzureGenericResources
  name 'azure_data_factory_pipelines'
  desc 'List azure pipelines by  data factory.'
  example <<-EXAMPLE
      describe azure_data_factory_pipelines(resource_group: 'example', factory_name: 'fn') do
        it { should exist }
      end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/
    #   providers/Microsoft.DataFactory/factories/{factoryName}/pipelines?api-version=2018-06-01
    opts[:resource_provider] = specific_resource_constraint('Microsoft.DataFactory/factories', opts)
    opts[:required_parameters] = %i(factory_name)
    opts[:resource_path] = [opts[:factory_name], 'pipelines'].join('/')
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
    # Check if the resource is failed.
    # It is recommended to check that after every usage of superclass methods or API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    #   - column: It is defined as an instance method, callable on the resource, and present `field` values in a list.
    #   - field: It has to be identical with the `key` names in @table items that will be presented in the FilterTable.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md

    # FilterTable is populated at the very end due to being an expensive operation.
    populate_filter_table_from_response
  end

  def to_s
    super(AzureDataFactoryPipelines)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:properties])
    end
  end
end
