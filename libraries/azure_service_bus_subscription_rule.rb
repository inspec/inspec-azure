require 'azure_generic_resource'

class AzureServiceBusSubscriptionRule < AzureGenericResource
  name 'azure_service_bus_subscription_rule'
  desc 'Retrieves and verifies the settings of an Azure Service Bus Subscription Rule.'
  example <<-EXAMPLE
    describe azure_service_bus_subscription_rule(resource_group: 'inspec-rg', namespace_name: 'inspec-ns', topic_name: 'inspec-topic', subscription_name: 'inspec-sub', name: 'inspec_rule1') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ServiceBus/namespaces', opts)
    opts[:required_parameters] = %i(namespace_name topic_name subscription_name)
    opts[:resource_path] = "#{opts[:namespace_name]}/topics/#{opts[:topic_name]}/subscriptions/#{opts[:subscription_name]}/rules"
    super(opts, true)
  end

  def to_s
    super(AzureServiceBusSubscriptionRule)
  end
end
