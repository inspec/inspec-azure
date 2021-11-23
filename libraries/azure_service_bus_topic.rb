require 'azure_generic_resource'

class AzureServiceBusTopic < AzureGenericResource
  name 'azure_service_bus_topic'
  desc 'Retrieves and verifies the settings of an Azure Service Bus Topic.'
  example <<-EXAMPLE
    describe azure_service_bus_topic(resource_group: 'inspec-group', name: 'inspec_ns') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ServiceBus/namespaces', opts)
    opts[:resource_path] = 'topics'
    super(opts, true)
  end

  def to_s
    super(AzureServiceBusTopic)
  end
end
