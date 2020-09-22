---
title: About the azure_network_security_groups Resource
platform: azure
---

# azure_network_security_groups

Use the `azure_network_security_groups` InSpec audit resource to enumerate Network Security Groups.

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

An `azure_network_security_groups` resource block returns all Azure network security groups, either within a Resource Group (if provided), or within an entire Subscription.
```ruby
describe azure_network_security_groups do
  #...
end
```
or
```ruby
describe azure_network_security_groups(resource_group: 'my-rg') do
  #...
end
```
## Parameters

- `resource_group` (Optional)

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| ids           | A list of the unique resource ids.                                                   | `id`            |
| locations     | A list of locations for all the network security groups.                             | `location`      |
| names         | A list of all the network security group names.                                      | `name`          |
| tags          | A list of `tag:value` pairs defined on the resources.                                | `tags`          |
| etags         | A list of etags defined on the resources.                                            | `etag`          |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test that an Example Resource Group Has the Named Network Security Group

```ruby
describe azure_network_security_groups(resource_group: 'ExampleGroup') do
  its('names') { should include('ExampleNetworkSecurityGroup') }
end
```

### Filters the Network Security Groups at Azure API to Only Those that Match the Given Name via Generic Resource (Recommended)
```ruby
# Fuzzy string matching
describe azure_generic_resources(resource_provider: 'Microsoft.Network/networkSecurityGroups', substring_of_name: 'project_A') do
  it { should exist }
end

# Exact name matching
describe azure_generic_resources(resource_provider: 'Microsoft.Network/networkSecurityGroups', name: 'project_A') do
  it { should exist }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the resource returns a result. Use `should_not` if you expect zero matches.
```ruby
# If we expect 'ExampleGroup' Resource Group to have Network Security Groups
describe azure_network_security_groups(resource_group: 'ExampleGroup') do
  it { should exist }
end

# If we expect 'EmptyExampleGroup' Resource Group to not have Network Security Groups
describe azure_network_security_groups(resource_group: 'EmptyExampleGroup') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
