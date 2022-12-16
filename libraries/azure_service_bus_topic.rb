require "azure_generic_resource"

class AzureServiceBusTopic < AzureGenericResource
  name "azure_service_bus_topic"
  desc "Retrieves and verifies the settings of an Azure Service Bus Topic."
  example <<-EXAMPLE
    describe azure_service_bus_topic(resource_group: 'inspec-group', namespace_name: 'inspec-ns', name: 'inspec-topic') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.ServiceBus/namespaces", opts)
    opts[:required_parameters] = %i(namespace_name)
    opts[:resource_path] = "#{opts[:namespace_name]}/topics"
    super(opts, true)
  end

  def to_s
    super(AzureServiceBusTopic)
  end
end
