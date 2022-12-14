resource_group = input(:resource_group, value: "")
service_bus_namespace_name = input(:service_bus_namespace_name, value: "")
service_bus_subscription_name = input(:service_bus_subscription_name, value: "")
service_bus_topic_name = input(:service_bus_topic_name, value: "")
service_bus_subscription_rule_name = input(:service_bus_subscription_rule_name, value: "")

control "Verify the settings for all Azure Service Bus Subscription Rules" do
  describe azure_service_bus_subscription_rules(resource_group: resource_group, namespace_name: service_bus_namespace_name, subscription_name: service_bus_subscription_name, topic_name: service_bus_topic_name) do
    it { should exist }
    its("name") { should include service_bus_subscription_rule_name }
    its("type") { should include "Microsoft.ServiceBus/Namespaces/Topics/Subscriptions/Rules" }
    its("filterTypes") { should include "SqlFilter" }
  end
end
