---
title: About the azure_iothub Resource
platform: azure
---

# azure_iothub

Use the `azure_iothub` InSpec audit resource to test properties of an Azure IoT hub within a Resource Group.

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

The `resource_group` and `name` must be given as a parameter.
```ruby
describe azure_iothub(resource_group: 'my-rg', name: 'my-iot-hub') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| name                           | The unique name of the IoT hub. `resourceName`                           |
| resource_name                  | Alias for the `name` parameter.                                                    |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`
- `resource_group` and `resource_name`

## Properties

| Property          | Description |
|-------------------|-------------|
| sku               | The SKU of the resource with [these](https://docs.microsoft.com/en-us/rest/api/iothub/iothubresource/get#iothubskuinfo) properties. |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/iothub/iothubresource/get#iothubdescription) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test if File Upload Notifications are Enabled
```ruby
describe azure_iothub(resource_group: 'my-rg', name: 'my-iot-hub') do
  its('properties.enableFileUploadNotifications') { should cmp true }
end
```
```ruby
describe azure_iothub(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Devices/IotHubs/{resourceName}') do
  its('properties.enableFileUploadNotifications') { should cmp true }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### exists
```ruby
# If we expect the resource to always exist
describe azure_iothub(resource_group: 'my-rg', name: 'my-iot-hub') do
  it { should exist }
end

# If we expect the resource to never exist
describe azure_iothub(resource_group: 'my-rg', name: 'my-iot-hub') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
