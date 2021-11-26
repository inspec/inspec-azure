---
title: About the azure_service_bus_subscription_rule Resource
platform: azure
---

# azure_service_bus_subscription_rule

Use the `azure_service_bus_subscription_rule` InSpec audit resource to test properties related to an Azure Service Bus Subscription Rule.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group`, `namespace_name`, `subscription_name`, `topic_name` and `name` are required parameters.

```ruby
describe azure_service_bus_subscription_rule(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', subscription_name: "SUBSCRIPTION_NAME", topic_name: 'TOPIC_NAME', name: 'SUBSCRIPTION_RULE_NAME') do 
  it                                      { should exist }
  its('type')                             { should eq 'Microsoft.ServiceBus/Namespaces/Topics/Subscriptions/Rules' }
  its('properties.filterType')            { should eq 'SqlFilter' }
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Service Bus Subscription Rule to test.                         |
| namespace_name | The namespace name.                                                              |
| subscription_name | The subscription name.                                                        |
| topic_name     | The topic name.                                                                  |
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |

The parameter set should be provided for a valid query:
- `resource_group`, `namespace_name`, `subscription_name`, `topic_name` and `name`

## Properties

| Property                 | Description                                                      |
|--------------------------|------------------------------------------------------------------|
| id                       | Resource Id.                                                     |
| name                     | Resource name.                                                   |
| type                     | Resource type.                                                   |
| properties               | The properties of the Service Bus Subscription Rule.             |
| properties.action        | Represents the filter actions which are allowed for the transformation of a message that have been matched by a filter expression. |
| properties.filterType    | Filter type that is evaluated against a BrokeredMessage.         |
| properties.sqlFilter     | Properties of sqlFilter.                                         |


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/servicebus/stable/rules/get) for other properties available.

## Examples

### Test that the Service Bus Subscription Rule is of SQL Filter type.

```ruby
describe azure_service_bus_subscription_rule(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', subscription_name: "SUBSCRIPTION_NAME", topic_name: 'TOPIC_NAME', name: 'SUBSCRIPTION_RULE_NAME') do
  its('properties.filterType') { should eq 'SqlFilter' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a Service Bus Subscription Rule is found it will exist
describe azure_service_bus_subscription_rule(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', subscription_name: "SUBSCRIPTION_NAME", topic_name: 'TOPIC_NAME', name: 'SUBSCRIPTION_RULE_NAME') do
  it { should exist }
end
# if Service Bus Subscription Rule is not found it will not exist
describe azure_service_bus_subscription_rule(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', subscription_name: "SUBSCRIPTION_NAME", topic_name: 'TOPIC_NAME', name: 'SUBSCRIPTION_RULE_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `reader` role on the subscription you wish to test.