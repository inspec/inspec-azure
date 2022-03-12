require 'azure_generic_resources'

class AzureServiceBusSubscriptionRules < AzureGenericResources
  name 'azure_service_bus_subscription_rules'
  desc 'Verifies settings for a collection of Azure Service Bus Subscription Rules in a Resource Group.'
  example <<-EXAMPLE
    describe azure_service_bus_subscription_rules(resource_group: 'inspec-rg', namespace_name: 'inspec-ns', subscription_name: 'inspec-subs', topic_name: 'inspec-topic') do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ServiceBus/namespaces', opts)
    opts[:required_parameters] = %i(namespace_name topic_name subscription_name)
    opts[:resource_path] = "#{opts[:namespace_name]}/topics/#{opts[:topic_name]}/subscriptions/#{opts[:subscription_name]}/rules"
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureServiceBusSubscriptionRules)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:properties]).merge(resource.dig(:properties, :sqlFilter))
    end
  end
end
