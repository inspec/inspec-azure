---
title: About the azure_lock Resource
platform: azure
---

# azure_lock

Use the `azure_lock` InSpec audit resource to test properties and configuration of a management lock.

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

The management lock resources do not follow the common `resouce_group` and `name` pattern for identification.
As a result of that, the `resource_id` must be given as a parameter to the `azure_lock` resource.
The [`azure_locks`](azure_locks.md) resource can be used for gathering the management lock resource ids to be tested within the desired level, such as, subscription, resource group or individual resource.
```ruby
describe azure_lock(resource_id: '/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/locks/{lockName}') do
  it { should exist }
end
```
## Parameters

| Name                                  | Description                                                                       |
|---------------------------------------|-----------------------------------------------------------------------------------|
| resource_id                           | The unique resource ID. `/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/locks/{lockName}` |

## Properties

| Property                  | Description |
|---------------------------|-------------|
| properties.level          | The level of the lock. Possible values are: `NotSpecified`, `CanNotDelete`, `ReadOnly`. For more see [here](https://docs.microsoft.com/en-us/rest/api/resources/managementlocks/getatresourcelevel#locklevel). |
| properties.notes          | Notes about the lock. Maximum of 512 characters. |
| properties.owners         | A list of the owners of the lock with [these](https://docs.microsoft.com/en-us/rest/api/resources/managementlocks/getatresourcelevel#managementlockowner) properties. |

Please note that the properties can vary depending on the `api_version` used for the lookup.

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/resources/managementlocks/getatresourcelevel#managementlockobject) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`), eg. `properties.<attribute>`.

## Examples

### Test If a `ReadOnly` Management Lock Exist in a Specific Resource Group
```ruby
azure_locks(resource_group: 'example-group').ids.each do |id|
  describe azure_lock(resource_id: id) do
    its('properties.level') { should_not cmp `ReadOnly` }
  end
end
```
### Test If Management Locks on a Specific Resource Contain a Certain String
```ruby
azure_locks(resouce_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/virtualMachines/{vmName}').ids.each do |lock_id|
  describe azure_lock(resource_id: lock_id) do
    it('properties.notes') { should include 'contact jdoe@chef.io' }
  end
end
```    
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
# If we expect a resource to always exist
describe azure_lock(resource_id: '/subscriptions/..{lockName}') do
  it { should exist }
end
# If we expect a resource to never exist
describe azure_lock(resource_id: '/subscriptions/..{lockName}') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
