+++
title = "azure_snapshots Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_snapshots"
identifier = "inspec/resources/azure/azure_snapshots Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_snapshots` InSpec audit resource to test the properties and configurations of an Azure Snapshots.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

```ruby
describe azure_snapshots do
  it { should exist }
end
```

## Parameters

No required parameters.

## Properties

`ids`
: The id of the snapshot.

: **Field**: `id`

`names`
: The name of the snapshot.

: **Field**: `name`

`types`
: The type of the snapshot.

: **Field**: `type`

`locations`
: The location of the snapshot.

: **Field**: `location`

`properties`
: The properties of the snapshot.

: **Field**: `properties`

`skus`
: The sku of the snapshot.

: **Field**: `sku`

{{% inspec_filter_table %}}

Also, refer to [Azure documentation](https://learn.microsoft.com/en-us/rest/api/compute/snapshots/list-by-resource-group?tabs=HTTP) for other properties available.

## Examples

### Test if a Snapshot is referenced with a valid name

```ruby
describe azure_snapshots do
  it { should exist }
end
```

### Test if a Snapshot is referenced with an invalid name

```ruby
describe azure_snapshots do
  it { should_not exist }
end
```

### Test if a Snapshot has a valid type

```ruby
describe azure_snapshots do
  its('types') { should cmp 'Microsoft.Compute/snapshots' }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

The control passes if the filter returns at least one result. Use `should_not` if you expect zero matches.

```ruby
# If we expect resources to exist.

describe azure_snapshots do
  it { should exist }
end
```

```ruby
# If we expect resources not to exist.

describe azure_snapshots do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="contributor" %}}
