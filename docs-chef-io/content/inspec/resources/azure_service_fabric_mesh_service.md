+++
title = "azure_service_fabric_mesh_service Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_service_fabric_mesh_service"
identifier = "inspec/resources/azure/azure_service_fabric_mesh_service Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_service_fabric_mesh_service` InSpec audit resource to test properties of an Azure Service Fabric Mesh service.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

```ruby
describe azure_service_fabric_mesh_service(resource_group: 'RESOURCE_GROUP', name: 'SERVICE_FABRIC_MESH_SERVICE_NAME') do
  it                                      { should exist }
  its('type')                             { should eq 'Microsoft.ServiceFabricMesh/applications' }
end
```

```ruby
describe azure_service_fabric_mesh_service(resource_group: 'RESOURCE_GROUP', name: 'SERVICE_FABRIC_MESH_SERVICE_NAME') do
  it  { should exist }
end
```

## Parameters

`name` _(required)_
: Name of the Azure Service Fabric Mesh service to test.

`resource_group` _(required)_
: Azure resource group that the targeted resource resides in.

## Properties

`id`
: Resource Id.

`name`
: Resource name.

`type`
: Resource type. `Microsoft.ServiceFabricMesh/services`.

`properties`
: The properties of the SERVICE FABRIC MESH SERVICE.

`properties.osType`
: The Operating system type required by the code in service.

`properties.replicaCount`
: The number of replicas of the service to create. Defaults to 1 if not specified.

`properties.healthState`
: Describes the health state of an services resource.


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md#properties" >}}).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/servicefabric/sfmeshrp-api-service_get) for other properties available.

## Examples

**Test that the SERVICE FABRIC MESH SERVICE is healthy.**

```ruby
describe azure_service_fabric_mesh_service(resource_group: 'RESOURCE_GROUP', name: 'SERVICE_FABRIC_MESH_SERVICE_NAME') do
  its('properties.healthState') { should eq 'Ok' }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# If a SERVICE FABRIC MESH SERVICE is found it will exist

describe azure_service_fabric_mesh_service(resource_group: 'RESOURCE_GROUP', name: 'SERVICE_FABRIC_MESH_SERVICE_NAME') do
  it { should exist }
end
# if SERVICE FABRIC MESH SERVICE is not found it will not exist

describe azure_service_fabric_mesh_service(resource_group: 'RESOURCE_GROUP', name: 'SERVICE_FABRIC_MESH_SERVICE_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}
