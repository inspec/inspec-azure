---
title: About the azure_event_hub_namespace Resource
platform: azure
---

# azure_event_hub_namespace

Use the `azure_event_hub_namespace` InSpec audit resource to test properties and configuration of an Azure Event Hub Namespace within a Resource Group.

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

`resource_group` and `name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_event_hub_namespace(resource_group: 'my-rg', name: 'my-event-hub-ns') do
  it { should exist }
end
```
```ruby
describe azure_event_hub_namespace(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `resourceGroupName`   |
| name                           | The unique name of the Event Hub Namespace. `namespaceName`                       |
| namespace_name                 | Alias for the `name` parameter.                                                   |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`
- `resource_group` and `namespace_name`

## Properties

| Property                          | Description |
|-----------------------------------|-------------|
| properties.kafkaEnabled           | Value that indicates whether Kafka is enabled for eventhub namespace. |

For parameters applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/eventhub/2017-04-01/namespaces/get#ehnamespace) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test If Kafka is Enabled for an Eventhub Namespace
```ruby
describe azure_event_hub_namespace(resource_group: 'my-rg', namespace_name: 'my-event-hub-ns') do
  its('properties.kafkaEnabled') { should be true }
end
```
```ruby
describe azure_event_hub_namespace(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}') do
  its('properties.kafkaEnabled') { should be true }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### exists
```ruby
# If we expect the resource to always exist
describe azure_event_hub_namespace(resource_group: 'my-rg', namespace_name: 'my-event-hub-ns') do
  it { should exist }
end

# If we expect the resource not to exist
describe azure_event_hub_namespace(resource_group: 'my-rg', namespace_name: 'my-event-hub-ns') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
