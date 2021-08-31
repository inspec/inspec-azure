---
title: About the azure_migrate_project_machine Resource
platform: azure
---

# azure_migrate_project_machine

Use the `azure_migrate_project_machine` InSpec audit resource to test properties related to an Azure Migrate Project Machine.

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

`resource_group`, `project_name` & `name` is a required parameter.

```ruby
describe azure_migrate_project_machine(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_project', name: 'c042be9e-3d93-42cf-917f-b92c68318ded') do
  it                                      { should exist }
  its('properties.discoveryData') { should_not be_empty }
  its('properties.discoveryData.first') { should include({ osType: 'windowsguest' }) }
end
```

```ruby
describe azure_migrate_project_machine(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_project', name: 'c042be9e-3d93-42cf-917f-b92c68318ded') do
  it  { should exist }
end
```
## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Migrate Project Machine to test.                                   |
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| project_name   | Azure Migrate Assessment Project.                                                |

The parameter set should be provided for a valid query:
- `resource_group` and `project_name` and `name`

## Properties

| Property                      | Description                                                      |
|-------------------------------|------------------------------------------------------------------|
| id                            | Path reference to the Migrate Project Machine.                   |
| name                          | Unique name of an Migrate Project Machine.                       |
| type                          | Type of the object. `Microsoft.Migrate/MigrateProjects/Databases`|
| properties                    | Properties of the assessment.                                    |
| properties.assessmentData     | The assessment details of the machine published by various sources.|
| properties.discoveryData      | The discovery details of the machine published by various sources.|
| properties.migrationData      | The migration details of the machine published by various sources.|
| properties.lastUpdatedTime    | The time of the last modification of the machine.                 |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/migrate/projects/machines/get-machine) for other properties available.
Any attribute in the response nested within properties may be accessed with the key names separated by dots (`.`) and attributes nested in the assessmentData
is pluralized and listed as collection.

## Examples

### Test that the Migrate Project Machine has a Windows OS type.

```ruby
describe azure_migrate_project_machine(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_project', name: 'c042be9e-3d93-42cf-917f-b92c68318ded') do
  its('properties.discoveryData.first') { should include({ osType: 'windowsguest' }) }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a Migrate Project Machine is found it will exist
describe azure_migrate_project_machine(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_project', name: 'c042be9e-3d93-42cf-917f-b92c68318ded') do
  it { should exist }
end
# if Migrate Project Machine is not found it will not exist
describe azure_migrate_project_machine(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_project', name: 'c042be9e-3d93-42cf-917f-b92c68318ded') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.