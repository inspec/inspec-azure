---
title: About the azure_event_hub_event_hub Resource
platform: azure
---

# azure_event_hub_event_hub

Use the `azure_event_hub_event_hub` InSpec audit resource to test properties of an Azure Event Hub description within a Resource Group.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group`, `namespace_name` and `name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_event_hub_event_hub(resource_group: 'my-rg', namespace_name: 'my-event-hub-ns', name: 'myeventhub') do
  it { should exist }
end
```
```ruby
describe azure_event_hub_event_hub(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `resourceGroupName`   |
| namespace_name                 | The unique name of the Event Hub Namespace. `namespaceName`                       |
| name                           | The unique name of the targeted resource. `eventHubName`                          |
| event_hub_name                 | Alias for the `name` parameter.                                                   |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group`, `namespace_name` and `name`
- `resource_group`, `namespace_name` and `event_hub_name`

## Properties

| Property                          | Description |
|-----------------------------------|-------------|
| properties.messageRetentionInDays | Number of days to retain the events for this Event Hub, value should be 1 to 7 days. |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/eventhub/2017-04-01/eventhubs/get#eventhub) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test the Message Retention Time of an Event Hub
```ruby
describe azure_event_hub_event_hub(resource_group: 'my-rg', namespace_name: 'my-event-hub-ns', name: 'myeventhub') do
  its('properties.messageRetentionInDays') { should cmp 4 }
end
```
```ruby
describe azure_event_hub_event_hub(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}') do
  its('properties.messageRetentionInDays') { should cmp 4 }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### exists
```ruby
# If we expect the resource to always exist
describe azure_event_hub_event_hub(resource_group: 'my-rg', namespace_name: 'my-event-hub-ns', name: 'myeventhub') do
  it { should exist }
end

# If we expect the resource not to exist
describe azure_event_hub_event_hub(resource_group: 'my-rg', namespace_name: 'my-event-hub-ns', name: 'myeventhub') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
