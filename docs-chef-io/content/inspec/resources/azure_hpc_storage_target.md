+++
title = "azure_hpc_storage_target Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_hpc_storage_target"
identifier = "inspec/resources/azure/azure_hpc_storage_target Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_hpc_storage_target` InSpec audit resource to test properties related to an Azure HPC Storage Target.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

`name`, `cache_name`, `resource_group` is a required parameter.

```ruby
describe azure_hpc_storage_target(resource_group: 'RESOURCE_GROUP', cache_name: 'HPC_CACHE_NAME', name: 'HPC_STORAGE_TARGET_NAME') do
  it                                      { should exist }
  its('type')                             { should eq 'Microsoft.StorageCache/Cache/StorageTarget' }
  its('location')                         { should eq 'East US' }
end
```

```ruby
describe azure_hpc_storage_target(resource_group: 'RESOURCE_GROUP', cache_name: 'HPC_CACHE_NAME', name: 'HPC_STORAGE_TARGET_NAME') do
  it  { should exist }
end
```

## Parameters

`name` _(required)_
: Name of the Azure HPC Storage Targets to test.

`resource_group` _(required)_
: Azure resource group that the targeted resource resides in.

`cache_name` _(required)_
: Azure HPC Cache name

## Properties

`id`
: Resource ID of the Storage Target.

`name`
: Name of the Storage Target.

`type`
: Resource type. `Microsoft.StorageCache/Cache/StorageTarget`.

`location`
: Region name string.

`properties`
: The properties of the HPC Storage Target.

`properties.blobNfs`
: The properties when targetType is blobNfs.

`properties.state`
: The storage target operational state.

`properties.nfs3`
: Properties when targetType is nfs3.


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md#properties" >}}).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/storagecache/storage-targets/get#storagetarget) for other properties available.

## Examples

**Test that the HPC Storage Target is ready.**

```ruby
describe azure_hpc_storage_target(resource_group: 'RESOURCE_GROUP', cache_name: 'HPC_CACHE_NAME', name: 'HPC_STORAGE_TARGET_NAME') do
  its('properties.state') { should eq 'Ready' }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# If a HPC Storage Target is found it will exist

describe azure_hpc_storage_target(resource_group: 'RESOURCE_GROUP', cache_name: 'HPC_CACHE_NAME', name: 'HPC_STORAGE_TARGET_NAME') do
  it { should exist }
end
# if HPC Storage Target is not found it will not exist

describe azure_hpc_storage_target(resource_group: 'RESOURCE_GROUP', cache_name: 'HPC_CACHE_NAME', name: 'HPC_STORAGE_TARGET_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}
