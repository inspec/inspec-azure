---
title: About the azure_service_fabric_mesh_replicas Resource
platform: azure
---

# azure_service_fabric_mesh_replicas

Use the `azure_service_fabric_mesh_replicas` InSpec audit resource to test properties related to all Azure Service Fabric Mesh Replicas.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_service_fabric_mesh_replicas` resource block returns all Azure Service Fabric Mesh Replicas.

```ruby
describe azure_service_fabric_mesh_replicas(resource_group: 'RESOURCE_GROUP', application_name: 'SERVICE_FABRIC_MESH_APPLICATION_NAME', service_name: 'SERVICE_FABRIC_MESH_SERVICE_NAME') do
  #...
end
```

## Parameters
| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Service Fabric Mesh Applications to test.                      |
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| application_name | The identity of the application.                                               |
| service_name   | The identity of the service.                                                     | 

The parameter set should be provided for a valid query:
- `resource_group`,`application_name`, `service_name` and `name`

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| osTypes                        | A list of OS Types.                                                    | `osType`         |
| codePackages                   | A list of code packages.                                               | `codePackages`    |
| networkRefs                    | A list of the network Refs.                                            | `networkRefs`     |
| replicaNames                   | A list of the replica Names.                                           | `replicaName`     |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples


### Test that there are Service Fabric Mesh Replicas with at least 1 replica.

```ruby
describe azure_service_fabric_mesh_replicas(resource_group: 'RESOURCE_GROUP', application_name: 'SERVICE_FABRIC_MESH_APPLICATION_NAME', service_name: 'SERVICE_FABRIC_MESH_SERVICE_NAME').where{ replicaName > 1 } do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Service Fabric Mesh Replicas are present
describe azure_service_fabric_mesh_replicas(resource_group: 'RESOURCE_GROUP', application_name: 'SERVICE_FABRIC_MESH_APPLICATION_NAME', service_name: 'SERVICE_FABRIC_MESH_SERVICE_NAME') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Service Fabric Mesh Replicas
describe azure_service_fabric_mesh_replicas(resource_group: 'RESOURCE_GROUP', application_name: 'SERVICE_FABRIC_MESH_APPLICATION_NAME', service_name: 'SERVICE_FABRIC_MESH_SERVICE_NAME') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `reader` role on the subscription you wish to test.