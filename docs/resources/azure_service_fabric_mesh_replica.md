---
title: About the azure_service_fabric_mesh_replica Resource
platform: azure
---

# azure_service_fabric_mesh_replica

Use the `azure_service_fabric_mesh_replica` InSpec audit resource to test properties related to an Azure Service Fabric Mesh Application.

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

`name`, `resource_group` is a required parameter.

```ruby
describe azure_service_fabric_mesh_replica(resource_group: 'RESOURCE_GROUP', application_name: 'SERVICE_FABRIC_MESH_APPLICATION_NAME', service_name: 'SERVICE_FABRIC_MESH_SERVICE_NAME', name: 'SERVICE_FABRIC_MESH_SERVICE_REPLICA_NAME') do
  it                                      { should exist }
  its('type')                             { should eq 'Microsoft.ServiceFabricMesh/applications' }
  its('location')                         { should eq 'eastus' }
end
```

```ruby
describe azure_service_fabric_mesh_replica(resource_group: 'RESOURCE_GROUP', application_name: 'SERVICE_FABRIC_MESH_APPLICATION_NAME', service_name: 'SERVICE_FABRIC_MESH_SERVICE_NAME', name: 'SERVICE_FABRIC_MESH_SERVICE_REPLICA_NAME') do
  it  { should exist }
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

| Property                 | Description                                                      |
|--------------------------|------------------------------------------------------------------|
| osType                   | The Operating system type required by the code in service.       |
| codePackages             | Describes the set of code packages that forms the service.       |
| networkRefs              | The names of the private networks that this service needs to be part of.|
| replicaName              | Name of the replica.                                              |


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/servicefabric/sfmeshrp-api-replica_get) for other properties available.

## Examples

### Test that the Service Fabric Mesh Application Replica is equal to 1.

```ruby
describe azure_service_fabric_mesh_replica(resource_group: 'RESOURCE_GROUP', application_name: 'SERVICE_FABRIC_MESH_APPLICATION_NAME', service_name: 'SERVICE_FABRIC_MESH_SERVICE_NAME', name: 'SERVICE_FABRIC_MESH_SERVICE_REPLICA_NAME') do
  its('replicaName') { should eq '1' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a Service Fabric Mesh Application is found it will exist
describe azure_service_fabric_mesh_replica(resource_group: 'RESOURCE_GROUP', application_name: 'SERVICE_FABRIC_MESH_APPLICATION_NAME', service_name: 'SERVICE_FABRIC_MESH_SERVICE_NAME', name: 'SERVICE_FABRIC_MESH_SERVICE_REPLICA_NAME') do
  it { should exist }
end
# if Service Fabric Mesh Application is not found it will not exist
describe azure_service_fabric_mesh_replica(resource_group: 'RESOURCE_GROUP', application_name: 'SERVICE_FABRIC_MESH_APPLICATION_NAME', service_name: 'SERVICE_FABRIC_MESH_SERVICE_NAME', name: 'SERVICE_FABRIC_MESH_SERVICE_REPLICA_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `reader` role on the subscription you wish to test.