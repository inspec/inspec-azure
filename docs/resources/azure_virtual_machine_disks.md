---
title: About the azure_virtual_machine_disks Resource
platform: azure
---

# azure_virtual_machine_disks

Use the `azure_virtual_machine_disks` InSpec audit resource to test properties related to disks for a resource group or the entire subscription.

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

An `azure_virtual_machine_disks` resource block returns all disks, either within a Resource Group (if provided), or within an entire Subscription.
```ruby
describe azure_virtual_machine_disks do
  it { should exist }
end
```
or
```ruby
describe azure_virtual_machine_disks(resource_group: 'my-rg') do
  it { should exist }
end
```
## Parameters

- `resource_group` (Optional)

## Properties

|Property         | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|-----------------|--------------------------------------------------------------------------------------|-----------------|
| ids             | A list of the unique resource ids.                                                   | `id`            |
| attached        | Indicates whether the disk is currently mounted to a running VM.                     | `attached`      |
| resource_group  | A list of resource groups for all the disks.                                         | `resource_group`|
| names           | A list of names all the disks.                                                       | `name`          |
| locations       | A list of locations of the disks.                                                    | `location`      |
| properties      | A list of properties of the disks.                                                   | `properties`    |
| tags             | A list of `tag:value` pairs defined on the resources.                               | `tags`          |
  
<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
  
## Examples

### Filter the Attached Disks
```ruby
describe azure_virtual_machine_disks(resource_group: 'MyResourceGroup').where(attached: true) do
  it { should exist }
  its('count') { should eq 3}
end
```   
### Loop through Disks by Their Ids  
```ruby
azure_virtual_machine_disks.ids.each do |id|
  describe azure_virtual_machine_disk(resource_id: id) do
    it { should exist }
  end
end  
``` 
### Test that There are Disks that Include a Certain String in their Names (Client Side Filtering)   
```ruby
describe azure_virtual_machine_disks(resource_group: 'MyResourceGroup').where { name.include?('Windows') } do
  it { should exist }
end
```    
### Test that There are Disks that Include a Certain String in their Names (Server Side Filtering via Generic Resource - Recommended)   
```ruby
describe azure_generic_resources(resource_provider: 'Microsoft.Compute/disks', substring_of_name: 'Windows') do
  it { should exist }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
# Should not exist if no disks are in the resource group
describe azure_virtual_machine_disks(resource_group: 'MyResourceGroup') do
  it { should_not exist }
end

# Should exist if the filter returns a single virtual machine
describe azure_virtual_machine_disks.where(attached: true ) do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
