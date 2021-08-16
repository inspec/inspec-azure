require 'azure_generic_resource'

class AzureDataFactoryGateway < AzureGenericResource
  name 'azure_data_factory_gateway'
  desc 'get azure gateway unr ta factory.'
  example <<-EXAMPLE
     describe azure_data_factory_gateway(resource_group: resource_group, factory_name: factory_name, gateway_name: gateway_name)  do
       it { should exist }
     end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    #
    # Azure REST API endpoint URL format for the resource:
    #   https://management.azure.com/subscriptions/{SubscriptionID}/resourcegroups/{ResourceGroupName}/
    #   providers/Microsoft.DataFactory/datafactories/{DataFactoryName}/gateways/{GatewayName}?api-version={api-version}
    #
    opts[:resource_provider] = specific_resource_constraint('Microsoft.DataFactory/datafactories', opts)
    opts[:required_parameters] = %i(factory_name)
    opts[:resource_path] = [opts[:factory_name], 'gateways'].join('/')
    opts[:resource_identifiers] = %i(gateway_name)
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureDataFactoryGateway)
  end
end
