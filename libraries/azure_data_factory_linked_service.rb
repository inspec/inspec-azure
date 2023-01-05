require "azure_generic_resource"

class AzureDataFactoryLinkedService < AzureGenericResource
  name "azure_data_factory_linked_service"
  desc "Checking azure data factory linked service"
  example <<-EXAMPLE
    describe azure_data_factory_linked_service(resource_group: 'RESOURCE_GROUP_NAME', factory_name: 'DATA_FACTORY_NAME', linked_service_name: 'LINKED_SERVICE_NAME')  do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)
    #
    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/
    #   providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}?api-version=2018-06-01
    #
    opts[:resource_provider] = specific_resource_constraint("Microsoft.DataFactory/factories", opts)
    opts[:required_parameters] = %i(factory_name)
    opts[:resource_path] = [opts[:factory_name], "linkedservices"].join("/")
    opts[:resource_identifiers] = %i(linked_service_name)
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureDataFactoryLinkedService)
  end

  def linked_service_type
    properties.type if exists?
  end

  def type_properties
    properties.typeProperties if exists?
  end
end
