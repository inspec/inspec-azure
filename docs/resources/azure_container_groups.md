---
title: About the azure_container_groups Resource
platform: azure
---

# azure_container_groups

Use the `azure_container_groups` InSpec audit resource to test properties related to all Azure Container Groups for the subscription.

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

An `azure_container_groups` resource block returns all Azure Container Groups within a Subscription.
```ruby
describe azure_container_groups do
  #...
end
```

## Parameters

## Properties

|Property            | Description                                                                      | Filter Criteria<superscript>*</superscript> |
|--------------------|----------------------------------------------------------------------------------|------------------|
| ids                | A list of the unique resource ids.                                               | `id`             |
| names              | A list of names for all the Resources.                                           | `name`           |
| types              | A list of types for all the resources.                                           | `type`           |
| locations          | A list of the resource location for all the resources.                           | `location`       |
| tags               | A list of tags for all the resources.                                            | `tags`           |
| properties         | A list of Properties all the resources.                                          | `properties`     |
| containers         | A list of containers within the container group.                                 | `containers`     | 
| init_containers    | A list of init containers for a container group.                                 | `init_containers`|
| image_registry_credentials| A list of image registry credentials by which the container group is created from.| `image_registry_credentials` |
| ip_address         | A list of IP address type of the container group.                                | `ip_address`     |
| os_types           | A list of operating system types required by the containers in the container group.| `os_type`      |
| provisioning_states| A list of provisioning states of the container group.                            | `provisioning_state`|
| volumes            | A list of volumes that can be mounted by containers in this container group.     | `volumes`        |
| skus               | A list SKU for a container group.                                                | `sku`            |
| restart_policies   | A list of restart policies for all containers within the container group.        | `restart_policy` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through Container Groups by Their Names
```ruby
azure_container_groups.names.each do |name|
  describe azure_container_group(resource_group: 'MyResourceGroup', name: name) do
    it { should exist }
  end
end  
```     
### Test that There are Container Groups with valid name
```ruby
describe azure_container_groups.where(name: 'app-service') do
  it { should exist }
end
```    

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
# Should not exist if no container groups are present in the subscription
describe azure_container_groups do
  it { should_not exist }
end

# Should exist if the filter returns at least one container group in the subscription
describe azure_container_groups do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.