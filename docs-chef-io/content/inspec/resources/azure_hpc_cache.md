+++
title = "azure_hpc_cache Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_hpc_cache"
identifier = "inspec/resources/azure/azure_hpc_cache Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_hpc_cache` InSpec audit resource to test properties related to an Azure HPC Cache.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

`name`, `cache_name`, `resource_group` is a required parameter.

```ruby
describe azure_hpc_cache(resource_group: 'RESOURCE_GROUP', name: 'HPC_CACHE_NAME') do
  it                                      { should exist }
  its('type')                             { should eq 'Microsoft.StorageCache/Cache' }
  its('location')                         { should eq 'East US' }
end
```

```ruby
describe azure_hpc_cache(resource_group: 'RESOURCE_GROUP', name: 'HPC_CACHE_NAME') do
  it  { should exist }
end
```

## Parameters

`name` _(required)_
: Name of the Azure HPC Cache to test.

`resource_group` _(required)_
: Azure resource group that the targeted resource resides in.

## Properties

`id`
: Resource ID of the HPC Cache.

`name`
: Name of the HPC Cache.

`type`
: Resource type. `Microsoft.StorageCache/Cache`.

`location`
: Region name string.

`properties`
: The properties of the HPC Cache.

`properties.cacheSizeGB`
: The size of this Cache, in GB.

`properties.subnet`
: The Subnet used for the Cache..

`properties.health`
: Health of the Cache..


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md#properties" >}}).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/storagecache/caches/get#cache) for other properties available.

## Examples

**Test that the HPC Cache is provisioned.**

```ruby
describe azure_hpc_cache(resource_group: 'RESOURCE_GROUP', name: 'HPC_CACHE_NAME') do
  its('properties.provisioningState') { should eq 'Succeeded' }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# If a HPC Cache is found it will exist

describe azure_hpc_cache(resource_group: 'RESOURCE_GROUP', name: 'HPC_CACHE_NAME') do
  it { should exist }
end
# if HPC Cache is not found it will not exist

describe azure_hpc_cache(resource_group: 'RESOURCE_GROUP', name: 'HPC_CACHE_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}