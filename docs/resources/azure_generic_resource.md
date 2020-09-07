---
title: About the azure_generic_resource Resource
platform: azure
---

# azure_generic_resource

Use the `azure_generic_resource` Inspec audit resource to test any valid Azure resource available through Azure Resource Manager. 

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax
```ruby
describe azure_generic_resource(resource_group: 'MyResourceGroup', name: 'MyResource') do
  its('property') { should eq 'value' }
end
```

where

* Resource parameters are used to query Azure Resource Manager endpoint for the resource to be tested.
* `property` - This generic resource dynamically creates the properties on the fly based on the type of resource that has been targeted.
* `value` is the expected output from the chosen property.

## Parameters

The following parameters can be passed for targeting a specific Azure resource.

| Name              | Description                                                                                                                                    |
|-------------------|----------------------------------------------------------------------------------------------------------|
| resource_group    | Azure resource group that the targeted resource has been created in. `MyResourceGroup`                   |
| name              | Name of the Azure resource to test. `MyVM`                                                               |
| resource_provider | Azure resource provider of the resource to be tested. `Microsoft.Compute/virtualMachines`                |
| resource_path     | Relative path to the resource if it is defined on another resource. Resource path of a subnet in a virtual network would be: `{virtualNetworkName}/subnets`. |
| resource_id       | Unique id of Azure resource to be tested. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/virtualMachines/{vmName}` |
| tag_name<superscript>*</superscript> | Tag name defined on the Azure resource. `name`                                                           |
| tag_value         | Tag value of the tag defined with the `tag_name`. `external_linux`                                       |
| api_version       | API version to use when interrogating the resource. If not set or the provided api version is not supported by the resource provider then the latest version for the resource provider will be used. `2017-10-9`, `latest`, `default`    |

<superscript>*</superscript> When resources are filtered by a tag name and value, the tags for each resource are not returned in the results.

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`
- `name`
- `resource_group`, `resource_provider` and `name`
- `resource_group`, `resource_provider`, `resource_path` and `name`
- `tag_name` and `tag_value`

Different parameter combinations can be tried. If it is not supported either the InSpec resource or the Azure Rest API will raise an error.

If the Azure Resource Manager endpoint returns multiple resources for a given query, this singular generic resource will fail. In that case, the [plural generic resource](azure_generic_resources.md) should be used. 

## Properties

The properties that can be tested are dependent on the Azure Resource that is tested. One way to see what properties can be tested is checking their API pages. For example for virtual machines, see [here](https://docs.microsoft.com/en-us/rest/api/compute/virtualmachines/get). 
Also the [Azure Resources Portal](https://resources.azure.com) can be used to select the resource you are interested in and see what can be tested.

The following properties are applicable to almost all resources.

| Property   | Description |
|------------|-------------|
| id         | The unique resource identifier.                          |
| name       | The name of the resource.                                |
| type       | The resource type.                                       |
| location   | The location of the resource.                            |
| tags       | The tag `key:value pairs` if defined on the resource.    |
| properties | The resource properties.                                 |

For more properties, refer to [Azure documents](https://docs.microsoft.com/en-us/rest/api/resources/resources/list#genericresourceexpanded).

## Examples

### Test Properties of a Virtual Machine and the Endpoint API Version
```ruby
describe azure_generic_resource(resource_group: 'my_vms', name: 'my_linux_vm') do
  its('properties.storageProfile.osDisk.osType') { should cmp 'Linux' }
  its('properties.storageProfile.osDisk.createOption') { should cmp 'FromImage' }
  its('properties.storageProfile.osDisk.name') { should cmp 'linux-external-osdisk' }
  its('properties.storageProfile.osDisk.caching') { should cmp 'ReadWrite' }
  
  its('api_version_used_for_query_state') { should eq 'latest' }
end
```
### Test the API Version Used for the Query
```ruby
describe azure_generic_resource(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/virtualMachines/{vmName}', api_version: '2017-01-01') do
  its('api_version_used_for_query_state') { should eq 'user_provided' }
  its('api_version_used_for_query') { should eq '2017-01-01' }
end
```
### Test the Tags if Include Specific Values
```ruby
describe azure_generic_resource(resource_group: 'my_vms', name: 'my_linux_vm') do
  its('tags') { should include(name: 'MyVM') }
  # The tag key name can be tested in String or Symbol.
  its('tags') { should include(:name) }    # regardless of the value
  its('tags') { should include('name') }    # regardless of the value
end
```
### Test Properties of a Virtual Machine Resides in an Azure Dev Test Lab 
```ruby
describe azure_generic_resource(resource_provider: 'Microsoft.DevTestLab/labs', resource_path: '{labName}/virtualmachines', resource_group: 'my_group', name: 'my_VM') do
  its('properties.userName') { should cmp 'admin' }
  its('properties.allowClaim') { should cmp false }
end
```
For more examples, please see the [integration tests](/test/integration/verify/controls/azure_generic_resource.rb).

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exist
```ruby
# Should not exist if there is no resource with a given name
describe azure_generic_resource(name: 'fake_name') do
  it { should_not exist }
end
```
```ruby
# Should exist if there is one resource with a given name
describe azure_generic_resource(name: 'a_very_unique_name_within_subscription') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
