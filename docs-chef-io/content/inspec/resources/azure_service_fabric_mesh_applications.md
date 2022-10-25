+++
title = "azure_service_fabric_mesh_applications Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_service_fabric_mesh_applications"
identifier = "inspec/resources/azure/azure_service_fabric_mesh_applications Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_service_fabric_mesh_applications` InSpec audit resource to test the properties of all Azure Service Fabric Mesh applications.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_service_fabric_mesh_applications` resource block returns all Azure Service Fabric Mesh applications.

```ruby
describe azure_service_fabric_mesh_applications do
  #...
end
```

## Parameters

`resource_group` _(optional)_
: Azure resource group where the targeted resource resides.

## Properties

`ids`
: A list of resource IDs.

: **Field**: `id`

`names`
: A list of resource names.

: **Field**: `name`

`types`
: A list of the resource types.

: **Field**: `type`

`properties`
: A list of Properties for all the Service Fabric Mesh applications.

: **Field**: `properties`

`locations`
: A list of the Geo-locations.

: **Field**: `location`

`provisioningStates`
: A list of provisioning states of the Service Fabric Mesh applications.

: **Field**: `provisioningState`

`healthStates`
: A list of the health states of a resource such as application, Service, or Network.

: **Field**: `healthState`

`serviceNames`
: A list of the services in the application.

: **Field**: `serviceNames`

{{% inspec_filter_table %}}

## Examples

### Loop through Service Fabric Mesh applications by their names

```ruby
azure_service_fabric_mesh_applications(resource_group: 'RESOURCE_GROUP').names.each do |name|
  describe azure_service_fabric_mesh_application(resource_group: 'RESOURCE_GROUP', name: name) do
    it { should exist }
  end
end
```

### Test that there are Service Fabric Mesh applications that are successfully provisioned

```ruby
describe azure_service_fabric_mesh_applications(resource_group: 'RESOURCE_GROUP').where(provisioningState: 'Succeeded') do
  it { should exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# Should not exist if no Service Fabric Mesh applications are present.

describe azure_service_fabric_mesh_applications(resource_group: 'RESOURCE_GROUP') do
  it { should_not exist }
end
```

### not_exists

```ruby
# Should exist if the filter returns at least one Service Fabric Mesh application.

describe azure_service_fabric_mesh_applications(resource_group: 'RESOURCE_GROUP') do
  it { should exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}
