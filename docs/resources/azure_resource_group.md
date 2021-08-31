---
title: About the azure_resource_group Resource
platform: azure
---

# azure_resource_group

Use the `azure_resource_group` InSpec audit resource to test properties and configuration of an Azure resource group.

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

`name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_resource_group(name: 'my_resource_group') do
  it { should exist }
end
```
```ruby
describe azure_resource_group(resource_id: '/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}') do
  it { should exist }
end
```
## Parameters

| Name                                  | Description |
|---------------------------------------|-------------|
| name                                  | Name of the resource group. `resourceGroupName` |
| resource_id                           | The unique resource ID. `/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `name`

## Properties

| Property                     | Description |
|------------------------------|-------------|
| properties.provisioningState | The provisioning state. `Succeeded` |

For properties applicable to all resources, such as `type`, `name`, `id`, `location`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/resources/policydefinitions/get#policydefinition) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`), eg. `properties.<attribute>`.

## Examples

### Test a Resource Group Location
```ruby
describe azure_resource_group(name: 'my_resource_group') do
  its('location') { should cmp 'eastus' }
end
```
### Test a Resource Group Provisioning State
```ruby
describe azure_resource_group(name: 'my_resource_group') do
  its('properties.provisioningState') { should cmp 'Succeeded' }
end
```    
### Test a Resource Group Tags
```ruby
describe azure_resource_group(name: 'my_resource_group') do
  its('tags') { should include(:owner) }
  its('tags') { should include(owner: 'InSpec') }
end
```    
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
# If we expect a resource group to always exist
describe azure_resource_group(name: 'my_resource_group') do
  it { should exist }
end
# If we expect a resource group to never exist
describe azure_resource_group(name: 'my_resource_group') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
