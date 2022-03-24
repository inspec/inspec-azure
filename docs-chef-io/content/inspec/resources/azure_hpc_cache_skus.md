+++
title = "azure_hpc_cache_skus Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_hpc_cache_skus"
identifier = "inspec/resources/azure/azure_hpc_cache_skus Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_hpc_cache_skus` InSpec audit resource to test properties related to all Azure HPC Cache SKUs.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_hpc_cache_skus` resource block returns all Azure HPC Cache SKUs.

```ruby
describe azure_hpc_cache_skus do
  #...
end
```

## Parameters

## Properties

`resourceTypes`
: A list of the type of resource the SKU applies to.

: **Field**: `resourceType`

`names`
: A list of SKU names.

: **Field**: `name`

`sizes`
: A list of the SKU sizes.

: **Field**: `size`

`tiers`
: A list of tiers of VM in a scale set.

: **Field**: `tier`

`kind`
: A list of kind of resources that are supported.

: **Field**: `kind`

{{% inspec_filter_table %}}

## Examples


**Test that there are Standard tier HPC Cache SKUs.**

```ruby
describe azure_hpc_cache_skus.where(tier: 'Standard') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no HPC Cache SKUs are present

describe azure_hpc_cache_skus do
  it { should_not exist }
end
# Should exist if the filter returns at least one HPC Cache SKUs

describe azure_hpc_cache_skus do
  it { should exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}
