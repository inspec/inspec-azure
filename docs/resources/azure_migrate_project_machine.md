---
title: About the azure_migrate_project_machine Resource
platform: azure
---

# azure_migrate_project_machine

Use the `azure_migrate_project_machine` InSpec audit resource to test the properties related to an Azure Migrate project machine.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter. If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client are used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group`, `project_name` and `name` are required parameters.

```ruby
describe azure_migrate_project_machine(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME', name: 'c042be9e-3d93-42cf-917f-b92c68318ded') do
  it{ should exist }
  its('properties.discoveryData') { should_not be_empty }
  its('properties.discoveryData.first') { should include({ osType: 'windowsguest' }) }
end
```

```ruby
describe azure_migrate_project_machine(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME', name: 'c042be9e-3d93-42cf-917f-b92c68318ded') do
  it  { should exist }
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Migrate project machine to test.                               |
| resource_group | Azure resource group that the targeted resource resides in.                      |
| project_name   | Azure Migrate assessment project name.                                           |

The parameter set must be provided for a valid query:

- `resource_group`, `project_name`, and `name`.

## Properties

| Property                      | Description                                                        |
|-------------------------------|--------------------------------------------------------------------|
| id                            | Path reference to the migrate project machine.                     |
| name                          | Unique name of a migrate project machine.                         |
| type                          | Type of the object. `Microsoft.Migrate/MigrateProjects/Databases`  |
| properties                    | Properties of the assessment.                                      |
| properties.assessmentData     | The assessment details of the machine published by various sources.|
| properties.discoveryData      | The discovery details of the machine published by various sources. |
| properties.migrationData      | The migration details of the machine published by various sources. |
| properties.lastUpdatedTime    | The time of the last modification of the machine.                  |

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/migrate/projects/machines/get-machine) for other properties available. Any attribute in the response nested within properties may be accessed with the key names separated by dots (`.`), and attributes nested in the **assessmentData** are pluralized and listed as a collection.

## Examples

### Test that the migrate project machine has a Windows OS

```ruby
describe azure_migrate_project_machine(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME', name: 'c042be9e-3d93-42cf-917f-b92c68318ded') do
  its('properties.discoveryData.first') { should include({ osType: 'windowsguest' }) }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a migrate project machine is found, it will exist
describe azure_migrate_project_machine(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME', name: 'c042be9e-3d93-42cf-917f-b92c68318ded') do
  it { should exist }
end
# if migrate project machine is not found, it will not exist
describe azure_migrate_project_machine(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME', name: 'c042be9e-3d93-42cf-917f-b92c68318ded') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
