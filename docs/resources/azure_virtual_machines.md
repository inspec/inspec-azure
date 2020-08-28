---
title: About the azure_virtual_machines Resource
platform: azure
---

# azure_virtual_machines

Use the `azure_virtual_machines` InSpec audit resource to test properties related to virtual machines for a resource group or the entire subscription.

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

An `azure_virtual_machines` resource block returns all Azure virtual machines, either within a Resource Group (if provided), or within an entire Subscription.
```ruby
describe azure_virtual_machines do
  #...
end
```
or
```ruby
describe azure_virtual_machines(resource_group: 'my-rg') do
  #...
end
```
## Parameters

- `resource_group` (Optional)

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| ids           | A list of the unique resource ids.                                                   | `id`            |
| os_disks      | A list of OS disk names for all the virtual machines.                                | `os_disk`       |
| data_disks    | A list of data disks for all the virtual machines.                                   | `data_disks`    |
| vm_names      | A list of all the virtual machine names.                                             | `name`          |
| platforms     | A list of virtual machine operation system platforms. Supported values are `windows` and `linux`.| `platform`|
| tags          | A list of `tag:value` pairs defined on the resources.                                | `tags`          |
  
<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md#a-where-method-you-can-call-with-hash-params-with-loose-matching).
  
## Examples

### Test If Any Virtual Machines Exist in the Resource Group
```ruby
describe azure_virtual_machines(resource_group: 'MyResourceGroup') do
  it { should exist }
end
```
### Filters Based on Platform
```ruby
describe azure_virtual_machines(resource_group: 'MyResourceGroup').where(platform: 'windows') do
  it { should exist }
end
```   
### Loop through Virtual Machines by Their Ids  
```ruby
azure_virtual_machines.ids.each do |id|
  describe azure_virtual_machine(resource_id: id) do
    it { should exist }
  end
end  
``` 
### Test If There are Windows Virtual Machines     
```ruby
describe azure_virtual_machines(resource_group: 'MyResourceGroup').where(platform: 'windows') do
  it { should exist }
end
```    
### Test that There are Virtual Machines that Includes a Certain String in their Names (Client Side Filtering)   
```ruby
describe azure_virtual_machines(resource_group: 'MyResourceGroup').where { name.include?('WindowsVm') } do
  it { should exist }
end
```    
### Test that There are Virtual Machine that Includes a Certain String in their Names (Server Side Filtering via Generic Resource - Recommended)   
```ruby
describe azure_generic_resources(resource_group: 'MyResourceGroup', resource_provider: 'Microsoft.Compute/virtualMachine', substring_of_name: 'WindowsVm') do
  it { should exist }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
# Should not exist if no virtual machines are in the resource group
describe azure_virtual_machines(resource_group: 'MyResourceGroup') do
  it { should_not exist }
end

# Should exist if the filter returns a single virtual machine
describe azure_virtual_machines(resource_group: 'MyResourceGroup').where(platform: 'windows') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
