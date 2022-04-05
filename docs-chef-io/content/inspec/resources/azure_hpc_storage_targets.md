+++
title = "azure_hpc_storage_targets Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_hpc_storage_targets"
identifier = "inspec/resources/azure/azure_hpc_storage_targets Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_hpc_storage_targets` InSpec audit resource to test the properties related to all Azure HPC Storage Targets.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_hpc_storage_targets` resource block returns all Azure HPC Storage Targets.

```ruby
describe azure_hpc_storage_targets(resource_group: 'RESOURCE_GROUP', cache_name: 'HPC_CACHE_NAME') do
  #...
end
```

## Parameters

`resource_group` _(required)_
: Azure resource group that the targeted resource resides in.

`cache_name` _(required)_
: Azure HPC Cache name.

## Properties

`ids`
: A list of resource IDs.

: **Field**: `id`

`names`
: A list of resource Names.

: **Field**: `name`

`types`
: A list of the resource types.

: **Field**: `type`

`properties`
: A list of Properties for all the HPC Storage Targets.

: **Field**: `properties`

`locations`
: A list of the resource locations.

: **Field**: `location`

`targetTypes`
: A list of the types of the storage target.

: **Field**: `targetType`

`states`
: A list of operational state of the storage target.

: **Field**: `provisioningState`

{{% inspec_filter_table %}}

## Examples

**Loop through HPC Storage Targets by their names.**

```ruby
azure_hpc_storage_targets(resource_group: 'RESOURCE_GROUP', cache_name: 'HPC_CACHE_NAME').names.each do |name|
  describe azure_hpc_storage_target(resource_group: 'RESOURCE_GROUP', cache_name: 'HPC_CACHE_NAME', name: name) do
    it { should exist }
  end
end
```

**Test that there are HPC Storage Targets that are ready.**

```ruby
describe azure_hpc_storage_targets(resource_group: 'RESOURCE_GROUP', cache_name: 'HPC_CACHE_NAME').where(state: 'Ready') do
  it { should exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# Should not exist if no HPC Storage Targets are present

describe azure_hpc_storage_targets(resource_group: 'RESOURCE_GROUP', cache_name: 'HPC_CACHE_NAME') do
  it { should_not exist }
end
# Should exist if the filter returns at least one HPC Storage Targets

describe azure_hpc_storage_targets(resource_group: 'RESOURCE_GROUP', cache_name: 'HPC_CACHE_NAME') do
  it { should exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}
