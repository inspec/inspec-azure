---
title: About the azure_container_registry Resource
platform: azure
---

# azure_container_registry

Use the `azure_container_registry` InSpec audit resource to test properties and configuration of an Azure Container Registry.

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

`resource_group` and `name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_container_registry(resource_group: 'inspec-resource-group-9', name: 'example_cr') do
  it { should exist }
end
```
```ruby
describe azure_container_registry(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.ContainerRegistry/registries/{registryName}') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| name                           | The unique name of the targeted resource. `registryName`                           |
| container_registry_name        | Alias for the `name` parameter.                                                   |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.ContainerRegistry/registries/{registryName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`
- `resource_group` and `container_registry_name`

## Properties

| Property          | Description |
|-------------------|-------------|
| id                | The identity of the container registry, if configured. |
| sku               | The SKU of the container registry. |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/containerregistry/registries/get#registry) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test the Status of the Retention Policy for Container Registry
```ruby
describe azure_container_registry(resource_group: 'resource_group', name: 'container_registry_name') do
  its('properties.status.retentionPolicy') { should cmp 'enabled' }
end
```
```ruby
describe azure_container_registry(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.ContainerRegistry/registries/{registryName}') do
  its('properties.status.retentionPolicy') { should cmp 'enabled' }
end
```

See [integration tests](../../test/integration/verify/controls/azure_container_registry.rb) for more examples.

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### exists
```ruby
# If we expect 'cr-1' to always exist
describe azure_container_registry(resource_group: 'example', name: 'cr-1') do
  it { should exist }
end

# If we expect 'cr-1' to never exist
describe azure_container_registry(resource_group: 'example', name: 'cr-1') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
