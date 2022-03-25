+++
title = "azure_hpc_caches Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_hpc_caches"
identifier = "inspec/resources/azure/azure_hpc_caches Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_hpc_caches` InSpec audit resource to test properties related to all Azure HPC Caches.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_hpc_caches` resource block returns all Azure HPC Caches.

```ruby
describe azure_hpc_caches do
  #...
end
```

## Parameters

`resource_group` _(optional)_
: Azure resource group that the targeted resource resides in.

## Properties

`ids`
: A list of resource IDs.

: **Field**: `id`

`names`
: A list of Cache Names.

: **Field**: `name`

`types`
: A list of the Cache types.

: **Field**: `type`

`properties`
: A list of Properties for all the HPC Caches.

: **Field**: `properties`

`locations`
: A list of the resource locations.

: **Field**: `location`

`cacheSizeGBs`
: A list of the sizes of the HPC Cache.

: **Field**: `cacheSizeGB`

`subnets`
: A list of subnet used for the HPC Cache.

: **Field**: `subnet`

{{% inspec_filter_table %}}

## Examples

**Loop through HPC Caches by their names.**

```ruby
azure_hpc_caches.names.each do |name|
  describe azure_hpc_cache(resource_group: 'RESOURCE_GROUP', cache_name: 'HPC_CACHE_NAME', name: name) do
    it { should exist }
  end
end
```

**Test that there are HPC Caches that are provisioned.**

```ruby
describe azure_hpc_caches.where(provisioningState: 'Succeeded') do
  it { should exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# Should not exist if no HPC Caches are present

describe azure_hpc_caches do
  it { should_not exist }
end
# Should exist if the filter returns at least one HPC Caches

describe azure_hpc_caches do
  it { should exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}