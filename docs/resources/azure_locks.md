---
title: About the azure_locks Resource
platform: azure
---

# azure_locks

Use the `azure_locks` InSpec audit resource to test properties and configuration of all management locks for an Azure resource or any level below it.

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

An `azure_locks` resource block returns all management locks, either within a Resource Group (if provided), or within an entire Subscription.
```ruby
describe azure_locks do
  it { should exist }
end
```
or
```ruby
describe azure_locks(resource_group: 'my-rg') do
  it { should exist }
end
```
Also, at resource level test can be done providing the following identifiers: `resource_group`, `resource_name` and `resource_type` or the `resource_id`.
```ruby
describe azure_locks(resource_group: 'rg-1', resource_name: 'my-VM', resource_type: 'Microsoft.Compute/virtualMachines') do
  it { should exist }
end
```
or
```ruby
describe azure_locks(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/virtualMachines/{vmName}') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| resource_name                  | Name of the Azure resource on which the management locks are being tested. `MyVM` |
| resource_type                  | Type of the Azure resource on which the management locks are being tested. `Microsoft.Compute/virtualMachines` |
| resource_id                    | The unique resource ID of the Azure resource on which the management locks are being tested. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/virtualMachines/{vmName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group`, `resource_name` and `resource_type`
- `resource_group`
- None for a subscription level test.

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| ids           | A list of the unique resource ids of the management locks.                           | `id`            |
| names         | A list of names of all the management locks being interrogated.                      | `name`          |
| properties    | A list of properties for all the management locks being interrogated.                | `properties`    |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Check If a Specific Management Lock is Present for a Resource
```ruby
describe azure_locks(resource_group: 'rg-1', resource_name: 'my-VM', resource_type: 'Microsoft.Compute/virtualMachines') do
  its('names')  { should include 'production_agents' }
end
```
### Filters the Results to Include Only Those Management Locks which Include the Given Name
```ruby
describe azure_locks.where{ name.include?('production') } do
  it { should exist }
end
```
### Loop through All Virtual Machines to Test If They have Management Locks Defined on
```ruby
azure_virtual_machines.ids.each do |id|
  describe azure_locks(resource_id: id) do
    it { should exist }
  end
end
``` 
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
describe azure_locks(resource_group: 'rg-1', resource_name: 'my-VM', resource_type: 'Microsoft.Compute/virtualMachines') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
