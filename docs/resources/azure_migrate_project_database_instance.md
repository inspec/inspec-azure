---
title: About the azure_migrate_project_database_instance Resource
platform: azure
---

# azure_migrate_project_database_instance

Use the `azure_migrate_project_database_instance` InSpec audit resource to test properties related to an Azure Migrate Project Database Instance.

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

`name` is a required parameter and `resource_group` could be provided as an optional parameter.

```ruby
describe azure_migrate_project_database_instance(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project', name: 'sql_db') do
  it                                      { should exist }
  its('name')                             { should eq 'sql_db' }
  its('type')                             { should eq 'Microsoft.Migrate/MigrateProjects/Databases' }
  its('solutionNames')                    { should include 'migrateDBSolution' }
end
```

```ruby
describe azure_migrate_project_database_instance(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project', name: 'sql_db') do
  it  { should exist }
end
```
## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Migrate Project Database Instance to test.                                   |
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| project_name   | Azure Migrate Assessment Project.                                                |

The parameter set should be provided for a valid query:
- `resource_group` and `project_name` and `name`

## Properties

| Property                      | Description                                                      |
|-------------------------------|------------------------------------------------------------------|
| id                            | Path reference to the Migrate Project Database Instance.                  |
| name                          | Unique name of an Migrate Project Database Instance.                      |
| type                          | Type of the object. `Microsoft.Migrate/MigrateProjects/Databases`|
| properties                    | Properties of the assessment.                                    |
| properties.assessmentData     | Assessment details of the database published by various sources. |
| assessmentIds                 | The database assessment scope/Ids.                               |
| migrationBlockersCounts       | The number of blocking changes found.                            |
| breakingChangesCounts         | The number of breaking changes found.                            |
| assessmentTargetTypes         | The assessed target database types.                              |
| solutionNames                 | The names of the solutions that sent the data.                   |
| instanceIds                   | The database servers' instance Ids.                              |
| databaseNames                 | The name of the databases.                                       |


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/migrate/projects/databases/get-database) for other properties available.
Any attribute in the response nested within properties may be accessed with the key names separated by dots (`.`) and attributes nested in the assessmentData
is pluralized and listed as collection.

## Examples

### Test that the Migrate Project Database Instance has a SQL assessmentTargetType.

```ruby
describe azure_migrate_project_database_instance(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project', name: 'sql_db') do
  its('assessmentTargetTypes') { should include 'SQL' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a Migrate Project Database Instance is found it will exist
describe azure_migrate_project_database_instance(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project', name: 'sql_db') do
  it { should exist }
end
# if Migrate Project Database Instance is not found it will not exist
describe azure_migrate_project_database_instance(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project', name: 'sql_db') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
