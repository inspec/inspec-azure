---
title: About the azure_redis_cache Resource
platform: azure
---

# azure_redis_cache

Use the `azure_redis_cache` InSpec audit resource to test the properties related to an Azure Redis cache.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. You can define the `api_version` as a resource parameter. If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group` and `name` are required parameters.

```ruby
    describe azure_redis_cache(resource_group: 'RESOURCE_GROUP', name: 'REDIS_CACHE_NAME') do
      it                                      { should exist }
      its('name')                             { should cmp 'REDIS_CACHE_NAME' }
      its('type')                             { should cmp 'Microsoft.Cache/Redis' }
      its('sku.name')                         { should cmp 'Standard' }
      its('sku.family')                       { should cmp 'C' }
      its('location')                         { should cmp 'southcentralus' }
    end
```

```ruby
    describe azure_redis_cache(resource_group: 'RESOURCE_GROUP', name: 'REDIS_CACHE_NAME') do
      it  { should exist }
  end
```

## Parameters

| Name                            | Description                                                                      |
|---------------------------------|----------------------------------------------------------------------------------|
| resource_group                  | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| name                            | Name of the Azure Redis cache to test.                                           |

The parameter set should be provided for a valid query:

- `resource_group` and `name`

## Properties

| Property                      | Description                                                      |
|-------------------------------|------------------------------------------------------------------|
| id                            | Resource ID.                                                     |
| name                          | Redis Cache Name.                                                |
| location                      | Redis Cache Location.                                            |
| type                          | Resource type.                                                   |
| tags                          | Resource tags.                                                   |
| properties.sku.name           | The type of Redis cache to deploy. Valid values: (Basic, Standard, Premium).|
| properties.sku.family         | The SKU family to use. Valid values: (C, P). (C = Basic/Standard, P = Premium).|
| properties.sku.capacity       | The size of the Redis cache to deploy. Valid values: for C (Basic/Standard) family (0, 1, 2, 3, 4, 5, 6), for P (Premium) family (1, 2, 3, 4).|
| properties.provisioningState  | Redis instance provisioning status.                               |
| properties.redisVersion       | Redis version.                                                    |
| properties.enableNonSslPort   | Specifies whether the non-ssl Redis server port (6379) is enabled.|

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/redis/redis/get) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test that the Redis instance's provisioning status equals 'Succeeded'

```ruby
    describe azure_redis_cache(resource_group: 'RESOURCE_GROUP', name: 'REDIS_CACHE_NAME') do
      its('properties.provisioningState') { should eq 'Succeeded' }
    end
```

### Test that the Redis instance Skuname equals 'Standard_1vCores'

**Skuname** is the Redis cache to deploy. Valid values are `Basic`, `Standard`, `Premium`.

```ruby
<<<<<<< HEAD
    describe azure_redis_cache(resource_group: 'RESOURCE_GROUP', name: 'REDIS_CACHE_NAME') do
      its('properties.sku.name') { should 'Standard' }
    end
=======
describe azure_redis_cache(resource_group: 'MyResourceGroup', name: 'inspec-compliance-redis-cache') do
  its('properties.sku.name') { should 'Standard' }
end
>>>>>>> 810b7b3ba47a6c9f6f3574ef88d76f224a77df99
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a redis cache is found it will exist
    describe azure_redis_cache(resource_group: 'RESOURCE_GROUP', name: 'REDIS_CACHE_NAME') do
      it { should exist }
    end

# Redis Caches that aren't found will not exist
    describe azure_redis_cache(resource_group: 'RESOURCE_GROUP', name: 'REDIS_CACHE_NAME') do
      it { should_not exist }
    end
```

### be_enabled_non_ssl_port

Ensure that the Redis Cache supports non-SSL ports.

```ruby
    describe azure_redis_cache(resource_group: 'RESOURCE_GROUP', name: 'REDIS_CACHE_NAME') do
      it { should be_enabled_non_ssl_port }
    end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
