+++
title = "azure_service_fabric_mesh_replicas Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_service_fabric_mesh_replicas"
identifier = "inspec/resources/azure/azure_service_fabric_mesh_replicas Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_service_fabric_mesh_replicas` InSpec audit resource to test properties of all Azure Service Fabric Mesh replicas.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_service_fabric_mesh_replicas` resource block returns all Azure Service Fabric Mesh replicas.

```ruby
describe azure_service_fabric_mesh_replicas(resource_group: 'RESOURCE_GROUP', application_name: 'SERVICE_FABRIC_MESH_APPLICATION_NAME', service_name: 'SERVICE_FABRIC_MESH_SERVICE_NAME') do
  #...
end
```

## Parameters

`resource_group` _(required)_
: Azure resource group that the targeted resource resides in. `MyResourceGroup`.

`application_name` _(required)_
: The identity of the application.

`service_name` _(required)_
: The identity of the service.

## Properties

`osTypes`
: A list of OS Types.

: **Field**: `osType`

`codePackages`
: A list of code packages.

: **Field**: `codePackages`

`networkRefs`
: A list of the network Refs.

: **Field**: `networkRefs`

`replicaNames`
: A list of the replica Names.

: **Field**: `replicaName`

{{% inspec_filter_table %}}

## Examples


**Test that there are Service Fabric Mesh replicas with at least one replica.**

```ruby
describe azure_service_fabric_mesh_replicas(resource_group: 'RESOURCE_GROUP', application_name: 'SERVICE_FABRIC_MESH_APPLICATION_NAME', service_name: 'SERVICE_FABRIC_MESH_SERVICE_NAME').where{ replicaName > 1 } do
  it { should exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# Should not exist if no Service Fabric Mesh replicas are present

describe azure_service_fabric_mesh_replicas(resource_group: 'RESOURCE_GROUP', application_name: 'SERVICE_FABRIC_MESH_APPLICATION_NAME', service_name: 'SERVICE_FABRIC_MESH_SERVICE_NAME') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Service Fabric Mesh replicas

describe azure_service_fabric_mesh_replicas(resource_group: 'RESOURCE_GROUP', application_name: 'SERVICE_FABRIC_MESH_APPLICATION_NAME', service_name: 'SERVICE_FABRIC_MESH_SERVICE_NAME') do
  it { should exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="reader" %}}
