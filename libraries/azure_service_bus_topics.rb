require 'azure_generic_resources'

class AzureServiceBusTopics < AzureGenericResources
  name 'azure_service_bus_topics'
  desc 'Verifies settings for a collection of Azure Service Bus Topics.'
  example <<-EXAMPLE
    describe azure_service_bus_topics(resource_group: 'RESOURCE_GROUP_NAME', namespace_name: 'NAMESPACE_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ServiceBus/namespaces', opts)
    opts[:required_parameters] = %i(namespace_name)
    opts[:resource_path] = "#{opts[:namespace_name]}/topics"
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureServiceBusTopics)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:properties])
    end
  end
end
