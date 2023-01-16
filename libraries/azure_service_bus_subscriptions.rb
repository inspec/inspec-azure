require "azure_generic_resources"

class AzureServiceBusSubscriptions < AzureGenericResources
  name "azure_service_bus_subscriptions"
  desc "Verifies settings for a collection of Azure Service Bus Subscriptions in a Resource Group."
  example <<-EXAMPLE
    describe azure_service_bus_subscriptions(resource_group: 'inspec-rg', namespace_name: 'inspec-ns', topic_name: 'inspec-topic') do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.ServiceBus/namespaces", opts)
    opts[:required_parameters] = %i(namespace_name topic_name)
    opts[:resource_path] = "#{opts[:namespace_name]}/topics/#{opts[:topic_name]}/subscriptions"
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureServiceBusSubscriptions)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:properties]).merge(resource.dig(:properties, :countDetails))
    end
  end
end
