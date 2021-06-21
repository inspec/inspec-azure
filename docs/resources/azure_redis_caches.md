---
title: About the azure_redis_caches Resource
platform: azure
---

# azure_redis_caches

Use the `azure_redis_caches` InSpec audit resource to test properties related to Azure Redis Cache for a resource group or the entire subscription.

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

An `azure_redis_caches` resource block returns all Azure Redis Caches within a Resource Group.
```ruby
describe azure_redis_caches(resource_group: 'my-rg') do
  #...
end
```
or
```ruby
describe azure_redis_caches(resource_group: 'my-rg') do
  #...
end
```
## Parameters

The parameter should be provided for valid query
- `resource_group`

| Name                            | Description                                                                      |
|---------------------------------|----------------------------------------------------------------------------------|
| resource_group                  | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |

## Properties

|Property            | Description                                        | Filter Criteria<superscript>*</superscript> |
|--------------------|----------------------------------------------------|-----------------|
| ids                | A list of the unique resource ids.                 | `id`            |
| names              | A list of name for all the Resource names.         | `name`          |
| types              | A list of types for all the resources.             | `type`          |
| locations          | A list of locations for all the resources.         | `location`      |
| properties         | A list of Properties all the resources.            | `properties`    |
| tags               | A list of resource tags.                           | `tags`          |
| sku_names          | A list of SKU names.                               | `sku_name`      |
| sku_capacities     | A list of SKU capacities.                          | `sku_capacitie` |
| sku_families       | A list of SKU families.                            | `sku_family`    | 
| instances_ssl_ports| A list of redis instance SSL Ports.                | `instances_ssl_ports` |
| is_master_instance | A list of redis instance is_master flag.           | `is_master_instance` |
| is_primary_instance| A list of redis instance is_primary flag.          | `is_primary_instance` |
| max_clients        | A list of max clients in redis configuration.      | `max_clients`   |
| max_memory_reserves| A list of max memory reserves in redis configuration.| `max_memory_reserves` |
| max_fragmentation_memory_reserves| A list of max fragmentation memory reserves in redis configuration. | `max_fragmentation_memory_reserves` |
| max_memory_deltas  | A list of max memory deltas in redis configuration | `max_memory_deltas`|
| provisioning_states| A list of provisioning_states from the properties. | `provisioning_state` |
| redis_versions     | A list of redis versions from the properties.      | `redis_versions` |
| enable_non_ssl_port | A list of enabled non_ssl_port flag from the properties. | `enable_non_ssl_port` |
| public_network_access | A list of public network access from the properties. | `public_network_access` |
| access_keys        | A list of access keys from the properties.         | `access_keys`   |
| host_names         | A list of hostnames from the properties.           | `host_names`    | 
| ports              | A list of ports from the properties.               | `ports`         |
| ssl_ports          | A list of ssl ports from the properties.           | `ssl_ports`     |     
| linked_servers     | A list of linked_servers from the properties.      | `linked_servers`|


<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through Redis Caches by Their Names
```ruby
azure_redis_caches(resource_group: 'my-rg').names.each do |name|
  describe azure_redis_cache(name: name) do
    it { should exist }
  end
end  
```     
### Test that There are redis caches that includes a certain string in their names (Client Side Filtering)
```ruby
describe azure_redis_caches(resource_group: 'my-rg').where { name.include?('spec-client') } do
  it { should exist }
end
```    

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
# Should not exist if no redis caches are in the resource group
describe azure_redis_caches(resource_group: 'my-rg') do
  it { should_not exist }
end

# Should exist if the filter returns at least one redis cache
describe azure_redis_caches(resource_group: 'my-rg') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.