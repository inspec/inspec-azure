---
title: About the azure_iothub_event_hub_consumer_groups Resource
platform: azure
---

# azure_iothub_event_hub_consumer_groups

Use the `azure_iothub_event_hub_consumer_groups` InSpec audit resource to test properties and configuration of an Azure IoT Hub Event Hub Consumer Groups within a Resource Group.

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

The `resource_group`, `resource_name` and `event_hub_endpoint` must be given as a parameter.
```ruby
describe azure_iothub_event_hub_consumer_groups(resource_group: 'my-rg', resource_name: 'my-iot-hub', event_hub_endpoint: 'myeventhub') do
  its('names') { should include 'my-consumer-group'}
  its('types') { should include 'Microsoft.Devices/IotHubs/EventHubEndpoints/ConsumerGroups' }
end
```
## Parameters

| Name                           | Description                                                                          |
|--------------------------------|--------------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`        |
| resource_name                  | The name of the IoT hub. `my-iot-hub`                                                |
| event_hub_endpoint             | The name of the Event Hub-compatible endpoint in the IoT hub. `eventHubEndpointName` |

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| ids           | A list of the unique resource ids.                                                   | `id`            |
| locations     | A list of locations for all the resources being interrogated.                        | `location`      |
| names         | A list of names of all the resources being interrogated.                             | `name`          |
| tags          | A list of `tag:value` pairs defined on the resources being interrogated.             | `tags`          |
| types         | A list of the types of resources being interrogated.                                 | `type`          |
| properties    | A list of properties for all the resources being interrogated.                       | `properties`    |
| etags         | A list of etags defined on the resources.                                            | `etag`          |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Check If a Specific Consumer Group Exists
```ruby
describe azure_iothub_event_hub_consumer_groups(resource_group: 'my-rg', resource_name: 'my-iot-hub', event_hub_endpoint: 'myeventhub') do
  its('names') { should include('my_consumer_group') }
end
```
### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
# If we expect at least one resource to exists on a specified endpoint
describe azure_iothub_event_hub_consumer_groups(resource_group: 'my-rg', resource_name: 'my-iot-hub', event_hub_endpoint: 'myeventhub') do
  it { should exist }
end

# If we expect not to exist any consumer groups on a specified endpoint
describe azure_iothub_event_hub_consumer_groups(resource_group: 'my-rg', resource_name: 'my-iot-hub', event_hub_endpoint: 'myeventhub') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
