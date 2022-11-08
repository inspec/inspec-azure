+++
title = "azure_snapshot Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_snapshot"
identifier = "inspec/resources/azure/azure_snapshot Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_snapshot` InSpec audit resource to test the properties and configuration of an Azure Snapshot.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

`resource_group`, and `name` are required parameters.

```ruby
describe azure_snapshot(resource_group: 'RESOURCE_GROUP', name: 'SNAPSHOT_NAME') do
  it { should exist }
end
```

## Parameters

The below parameters are required.

`resource_group`
: Azure resource group where the targeted resource resides.

`name`
: The name of the snapshot that is being created.

## Properties

`id`
: The id of the snapshot.

`name`
: The name of the snapshot.

`type`
: The type of the snapshot.

`location`
: The location of the snapshot.

`properties`
: The properties of the snapshot.

`sku`
: The sku of the snapshot.

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md#properties" >}}).

Also, refer to [Azure documentation](https://learn.microsoft.com/en-us/rest/api/compute/snapshots/get?tabs=HTTP) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`). For example, `properties.<attribute>`.

## Examples

### Test if a Snapshot is referenced with a valid name

```ruby
describe azure_snapshot(resource_group: 'RESOURCE_GROUP', name: 'SNAPSHOT_NAME') do
  it { should exist }
end
```

### Test if a Snapshot is referenced with an invalid name

```ruby
describe azure_snapshot(resource_group: 'RESOURCE_GROUP', name: 'SNAPSHOT_NAME') do
  it { should_not exist }
end
```

### Test if a Snapshot has OS `Windows'

```ruby
describe azure_snapshot(resource_group: 'RESOURCE_GROUP', name: 'SNAPSHOT_NAME') do
  its('properties.osType') { should cmp 'Windows' }
end
```

### Test if the Snapshot has a valid disksize 

```ruby
describe azure_snapshot(resource_group: 'RESOURCE_GROUP', name: 'SNAPSHOT_NAME') do
  its('properties.diskSizeGB') { should cmp 127 }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# If we expect a resource to always exist.

describe azure_snapshot(resource_group: 'RESOURCE_GROUP', name: 'SNAPSHOT_NAME') do
  it { should exist }
end
```

```ruby
# If we expect a resource to never exist.

describe azure_snapshot(resource_group: 'RESOURCE_GROUP', name: 'SNAPSHOT_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="contributor" %}}
