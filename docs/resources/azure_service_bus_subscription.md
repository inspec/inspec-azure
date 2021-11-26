---
title: About the azure_service_bus_subscription Resource
platform: azure
---

# azure_service_bus_subscription

Use the `azure_service_bus_subscription` InSpec audit resource to test properties related to an Azure Service Bus Subscription.

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

`resource_group`, `namespace_name`, `topic_name` and `name` are required parameters.

```ruby
describe azure_service_bus_subscription(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', topic_name: 'TOPIC_NAME', name: 'SUBSCRIPTION_NAME') do 
  it                                      { should exist }
  its('type')                             { should eq 'Microsoft.ServiceBus/Namespaces/Topics/Subscriptions/Rules' }
  its('properties.filterType')            { should eq 'SqlFilter' }
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Service Bus Subscription to test.                         |
| namespace_name | The namespace name.                                                              |
| topic_name     | The topic name.                                                                  |
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |

The parameter set should be provided for a valid query:
- `resource_group`, `namespace_name`, `topic_name` and `name`

## Properties

| Property                 | Description                                                      |
|--------------------------|------------------------------------------------------------------|
| id                       | Resource Id.                                                     |
| name                     | Resource name.                                                   |
| type                     | Resource type.                                                   |
| properties               | The properties of the Service Bus Subscription.                  |
| properties.lockDuration  | ISO 8061 lock duration timespan for the subscription. The default value is 1 minute. |
| properties.status        | Enumerates the possible values for the status of a messaging entity.|
| properties.countDetails  | Message count details.                                           |


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/servicebus/stable/subscriptions/get) for other properties available.

## Examples

### Test that the Service Bus Subscription is active.

```ruby
describe azure_service_bus_subscription(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', topic_name: 'TOPIC_NAME', name: 'SUBSCRIPTION_NAME') do
  its('properties.status') { should eq 'Active' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a Service Bus Subscription is found it will exist
describe azure_service_bus_subscription(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', topic_name: 'TOPIC_NAME', name: 'SUBSCRIPTION_NAME') do
  it { should exist }
end
# if Service Bus Subscription is not found it will not exist
describe azure_service_bus_subscription(resource_group: 'RESOURCE_GROUP', namespace_name: 'NAMESPACE_NAME', topic_name: 'TOPIC_NAME', name: 'SUBSCRIPTION_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `reader` role on the subscription you wish to test.