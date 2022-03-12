+++
title = "azure_service_fabric_mesh_volumes Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_service_fabric_mesh_volumes"
identifier = "inspec/resources/azure/azure_service_fabric_mesh_volumes Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_service_fabric_mesh_volumes` InSpec audit resource to test properties of all Azure Service Fabric Mesh volumes.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_service_fabric_mesh_volumes` resource block returns all Azure Service Fabric Mesh volumes.

```ruby
describe azure_service_fabric_mesh_volumes do
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
: A list of resource Names.

: **Field**: `name`

`types`
: A list of the resource types.

: **Field**: `type`

`properties`
: A list of Properties for all the Service Fabric Mesh volumes.

: **Field**: `properties`

`locations`
: A list of the Geo-locations.

: **Field**: `location`

`provisioningStates`
: A list of provisioning states of the Service Fabric Mesh volumes.

: **Field**: `provisioningState`

`providers`
: A list of providers of the volume.

: **Field**: `provider`

`shareNames`
: A list of the Name of the Azure Files file share that provides storage for the volume.

: **Field**: `shareName`

{{% inspec_filter_table %}}

## Examples

**Loop through Service Fabric Mesh volumes by their names.**

```ruby
azure_service_fabric_mesh_volumes(resource_group: 'RESOURCE_GROUP').names.each do |name|
  describe azure_service_fabric_mesh_volume(resource_group: 'RESOURCE_GROUP', name: name) do
    it { should exist }
  end
end
```

**Test that there are Service Fabric Mesh volumes that are successfully provisioned.**

```ruby
describe azure_service_fabric_mesh_volumes(resource_group: 'RESOURCE_GROUP').where(provisioningState: 'Succeeded') do
  it { should exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# Should not exist if no Service Fabric Mesh volumes are present

describe azure_service_fabric_mesh_volumes(resource_group: 'RESOURCE_GROUP') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Service Fabric Mesh volumes

describe azure_service_fabric_mesh_volumes(resource_group: 'RESOURCE_GROUP') do
  it { should exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}
