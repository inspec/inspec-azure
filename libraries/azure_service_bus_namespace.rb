require 'azure_generic_resource'

class AzureServiceBusNamespace < AzureGenericResource
  name 'azure_service_bus_namespace'
  desc 'Retrieves and verifies the settings of an Azure Service Bus Namespace.'
  example <<-EXAMPLE
    describe azure_service_bus_namespace(resource_group: 'RESOURCE_GROUP_NAME', name: 'NAMESPACE_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ServiceBus/namespaces', opts)
    super(opts, true)
  end

  def to_s
    super(AzureServiceBusNamespace)
  end
end
