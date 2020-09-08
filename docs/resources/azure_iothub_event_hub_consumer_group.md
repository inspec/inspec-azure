---
title: About the azure_iothub_event_hub_consumer_group Resource
platform: azure
---

# azure_iothub_event_hub_consumer_group

Use the `azure_iothub_event_hub_consumer_group` InSpec audit resource to test properties and configuration of an Azure IoT Hub Event Hub Consumer Group within a Resource Group.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used .
For more information, refer to the resource pack [README](../../README.md). 

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group`, `resource_name`, `event_hub_endpoint` and `name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_iothub_event_hub_consumer_group(resource_group: 'my-rg', resource_name: 'my-iot-hub', event_hub_endpoint: 'myeventhub', name: 'my-consumer-group') do
  it { should exist }
end
```
```ruby
describe azure_iothub_event_hub_consumer_group(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/eventHubEndpoints/{eventHubEndpointName}/ConsumerGroups/{name}') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                          |
|--------------------------------|--------------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`        |
| resource_name                  | The name of the IoT hub. `my-iot-hub`                                                |
| event_hub_endpoint             | The name of the Event Hub-compatible endpoint in the IoT hub. `eventHubEndpointName` |
| name                           | The name of the consumer group to retrieve. `my-consumer-group`                      |
| consumer_group                 | Alias for the `name` parameter.                                                      |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/eventHubEndpoints/{eventHubEndpointName}/ConsumerGroups/{name}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group`, `resource_name`, `event_hub_endpoint` and `name`
- `resource_group`, `resource_name`, `event_hub_endpoint` and `consumer_group`

## Properties

| Property          | Description |
|-------------------|-------------|
| name              | The Event Hub-compatible consumer group name. |

For properties applicable to all resources, such as `type`, `tags`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/iothub/iothubresource/geteventhubconsumergroup#eventhubconsumergroupinfo) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test the Name of a Resource
```ruby
describe azure_iothub_event_hub_consumer_group(resource_group: 'my-rg', resource_name: 'my-iot-hub', event_hub_endpoint: 'myeventhub', name: 'my-consumer-group') do
  its('name') { should cmp 'my-consumer-group' }
end
```
```ruby
describe azure_iothub_event_hub_consumer_group(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}/eventHubEndpoints/{eventHubEndpointName}/ConsumerGroups/{name}') do
  its('name') { should cmp 'my-consumer-group' }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### exists
```ruby
# If we expect the resource to always exist
describe azure_iothub_event_hub_consumer_group(resource_group: 'my-rg', resource_name: 'my-iot-hub', event_hub_endpoint: 'myeventhub', name: 'my-consumer-group') do
  it { should exist }
end

# If we expect the resource to never exist
describe azure_iothub_event_hub_consumer_group(resource_group: 'my-rg', resource_name: 'my-iot-hub', event_hub_endpoint: 'myeventhub', name: 'my-consumer-group') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
