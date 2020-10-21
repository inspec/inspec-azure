---
title: About the azure_generic_resources Resource
platform: azure
---

# azure_generic_resources

Use the `azure_generic_resources` Inspec audit resource to test any valid Azure resources. 

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

This resource will interrogate all resource in your subscription available through Azure Resource Manager when initiated without a parameter.

```ruby
describe azure_generic_resources do
  it { should exist }
end
```

## Parameters

The following parameters can be passed for targeting Azure resources. 
All of them are optional. 

| Name                           | Description                                                                                                               | Example                             |
|--------------------------------|---------------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| resource_group                 | Azure resource group that the targeted resources have been created in.                                                    | `MyResourceGroup`                   |
| substring_of_resource_group    | Substring of an Azure resource group name that the targeted resources have been created in.                               | `My`                                |
| name                           | Name of the Azure resources to test.                                                                                      | `MyVM`                              |
| substring_of_name              | Substring of a name of the Azure resources to test.                                                                       | `My  `                              |
| resource_provider              | Azure resource provider of the resources to be tested.                                                                    | `Microsoft.Compute/virtualMachines` |
| tag_name<superscript>*</superscript> | Tag name defined on the Azure resources.                                                                            | `name`                              |
| tag_value                      | Tag value of the tag defined with the `tag_name`.                                                                         | `external_linux`                    |
| resource_uri                   | Azure REST API URI of the resources to be tested. This parameter should be used when resources do not reside in resource groups. It requires `add_subscription_id` parameter to be provided together. | `/providers/Microsoft.Authorization/policyDefinitions/` |
| add_subscription_id            | Indicates whether the `resource_uri` contains the subscription id. | `true` or `false` |
| filter_free_text               | Filter expression for the endpoints supporting `$filter` parameter, eg. [Azure role assignments](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-list-rest). This can only be used with the `resource_uri` parameter. | `"atScope()"` | 

<superscript>*</superscript> When resources are filtered by a tag name and value, the tags for each resource are not returned in the results.

Either one of the parameter sets can be provided for a valid query:
- `resource_group`
- `substring_of_resource_group`
- `name`
- `substring_of_name`
- `substring_of_resource_group` and `substring_of_name`
- `resource_provider`
- `resource_group` and `resource_provider`
- `substring_of_resource_group` and `resource_provider`
- `tag_name`
- `tag_name` and `tag_value`
- `add_subscription_id` and `resource_uri`
- `add_subscription_id`, `resource_uri` and `filter_free_text`

Different parameter combinations can be tried. If it is not supported either the InSpec resource or the Azure Rest API will raise an error.

It is advised to use these parameter sets to narrow down the targeted resources at the server side, Azure Rest API, for a more computing resource efficient test.

## Properties

| Property  | Description | Filter Criteria<superscript>*</superscript> |
|-----------|-------------|-----------------|
| ids       | A list of the unique resource ids. | `id`| 
| names     | A list of the resource names that are unique within a resource group.| `name`| 
| tags      | A list of `tag:value` pairs defined on the resources. | `tags`| 
| types     | A list of resource types. | `type`| 
| locations | A list of locations where resources are created in. | `location`| 
| created_times<superscript>**</superscript> | A list of created times of the resources. | `created_time`| 
| changed_times<superscript>**</superscript> | A list of changed times of the resources. | `changed_time`|
| provisioning_states<superscript>**</superscript> | A list of provisioning states of the resources. | `provisioning_state`|

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

<superscript>**</superscript> These properties are not available when `resource_uri` is used.

## Examples

### Test All Virtual Machines in Your Subscription
```ruby
describe azure_generic_resources(resource_provider: 'Microsoft.Compute/virtualMachines') do
  it { should exist }
  its('count') { should eq 43 }
end
```
### Test All Resources Regardless of Their Type and Resource Group with a Common String in Their Names (Server Side Filtering)
```ruby
azure_generic_resources(substring_of_name: 'project_a').ids.each do |id|
  describe azure_generic_resource(resource_id: id) do
    it { should exist }
    its('location') { should eq 'eastus' }
  end
end
```    
### Test All Resources Regardless of Their Type and Resource Group with a Common Tag `name:value` Pair (Server Side Filtering)
```ruby
azure_generic_resources(tag_name: 'demo', tag_value: 'shutdown_at_10_pm').ids.each do |id| 
  describe azure_generic_resource(resource_id: id) do
    it { should exist }
    its('location') { should eq 'eastus' }
  end
end
```    
### Filters the Results to Only Include Those that Match the Given Location (Client Side Filtering)
```ruby
describe azure_generic_resources.where(location: 'eastus') do
  it { should exist }
end
```
### Filters the Results to Only Include Those that Created within Last 24 Hours (Client Side Filtering)
```ruby
describe azure_generic_resources.where{ created_time > Time.now - 86400 } do
  it { should exist }
end
```
### Test Policy Definitions
```ruby
describe azure_generic_resources(add_subscription_id: true, resource_uri: 'providers/Microsoft.Authorization/policyDefinitions') do
  it { should exist }
end
```
### Filter Role Assignments via `filter_free_text`
```ruby
describe azure_generic_resources(add_subscription_id: true, resource_uri: "providers/Microsoft.Authorization/roleAssignments", filter_free_text: "atScope()+and+assignedTo('{abcd1234-abcd-1234}')") do
  it { should exist }
end
```
Please see [here](https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md) for more information on how to leverage FilterTable capabilities on plural resources. 

For more examples, please see the [integration tests](/test/integration/verify/controls/azure_generic_resources.rb).

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exist
```ruby
# Should not exist if there is no resource with a given resource group
describe azure_generic_resources(resource_group: 'fake_group') do
  it { should_not exist }
end
```
```ruby
# Should exist if there is at least one resource
describe azure_generic_resources(resource_group: 'MyResourceGroup') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.

