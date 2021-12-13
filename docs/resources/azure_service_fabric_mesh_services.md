---
title: About the azure_service_fabric_mesh_services Resource
platform: azure
---

# azure_service_fabric_mesh_services

Use the `azure_service_fabric_mesh_services` InSpec audit resource to test properties related to all Azure Service Fabric Mesh Services within a project.

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

An `azure_service_fabric_mesh_services` resource block returns all Azure Service Fabric Mesh Services within a project.

```ruby
describe azure_service_fabric_mesh_services do
  #...
end
```

## Parameters
| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup` (Optional)   |

The parameter set optionally be provided for a valid query:
- `resource_group`

## Properties

|Property                  | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------|------------------------------------------------------------------------|------------------|
| ids                      | A list of resource IDs.                                                | `id`             |
| names                    | A list of resource Names.                                              | `name`           |
| types                    | A list of the resource types.                                          | `type`           |
| properties               | A list of Properties for all the Service Fabric Mesh Services.         | `properties`     |
| osTypes                  | The Operating system type required by the code in services.            | `replicaCount`   |
| replicaCounts            | The number of replicas of the service to create. Defaults to 1 if not specified.| `metricId` |
| healthStates             | health state of an services resource                                   | `healthState`    |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through Service Fabric Mesh Services by their names.

```ruby
azure_service_fabric_mesh_services(resource_group: 'RESOURCE_GROUP').names.each do |name|
  describe azure_service_fabric_mesh_service(resource_group: 'RESOURCE_GROUP', name: name) do
    it { should exist }
  end
end
```
### Test that there are Service Fabric Mesh Services that are healthy.

```ruby
describe azure_service_fabric_mesh_services(resource_group: 'RESOURCE_GROUP').where(replicaCounts: 2) do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Service Fabric Mesh Services are present
describe azure_service_fabric_mesh_services(resource_group: 'RESOURCE_GROUP') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Service Fabric Mesh Services
describe azure_service_fabric_mesh_services(resource_group: 'RESOURCE_GROUP') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `reader` role on the subscription you wish to test.
