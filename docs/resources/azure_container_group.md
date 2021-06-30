---
title: About the azure_container_group Resource
platform: azure
---

# azure_container_group

Use the `azure_container_group` InSpec audit resource to test properties related to a Azure Container Group.

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

`name` must be given as a parameter and `resource_group` could be provided as an optional parameter
```ruby
describe azure_container_group(resource_group: 'MyResourceGroup', name: 'app-service') do
  it                                      { should exist }
  its('name')                             { should cmp 'demo1' }
  its('type')                             { should cmp 'Microsoft.ContainerInstance/containerGroups' }
  its('location')                         { should cmp 'WestUs'}
end
```
```ruby
describe azure_container_group(resource_group: 'MyResourceGroup', name: 'app-service') do
  it  { should exist }
end
```
## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Container Group to test.                                      |
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`|

The parameter set should be provided for a valid query:
- `resource_group` and `name` 

## Properties

| Property                      | Description                                                      |
|-------------------------------|------------------------------------------------------------------|
| id                            | Resource ID.                                                     |
| name                          | Container Group Name.                                            |
| type                          | Resource type.                                                   |
| location                      | The resource location.                                           |
| properties                    | The properties of the resource.                                  |


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/container-instances/container-groups/get) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test <>
```ruby
describe azure_container_group(resource_group: 'MyResourceGroup', name: 'app-service') do
  its('properties.ipAddress.type') { should eq 'Public'}
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists
```ruby
# If a container group is found it will exist
describe azure_container_group(resource_group: 'MyResourceGroup', name: 'app-service') do
  it { should exist }
end

# container groups that aren't found will not exist
describe azure_container_group(resource_group: 'MyResourceGroup', name: 'app-service') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.