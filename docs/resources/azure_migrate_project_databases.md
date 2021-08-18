---
title: About the azure_migrate_project_database Resource
platform: azure
---

# azure_migrate_project_database

Use the `azure_migrate_project_database` InSpec audit resource to test properties related to all Azure Migrate Project Databases within a project.

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

An `azure_migrate_project_database` resource block returns all Azure Migrate Project Databases within a project.

```ruby
describe azure_migrate_project_database(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_DB_project') do
  #...
end
```

## Parameters
| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| project_name   | Azure Migrate Project.                                                |

The parameter set should be provided for a valid query:
- `resource_group` and `project_name`

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | Path reference to the Project Databases.                               | `id`             |
| names                          | Unique names for all Project Databases.                                | `name`           |
| types                          | Type of the objects.                                                   | `type`           |
| properties                     | A list of Properties for all the Project Databases.                    | `properties`     |
| assessmentDatas                | The assessment details of the database published by various sources.   | `assessmentData` |
| assessmentIds                  | The database assessment scopes/Ids.                                    | `assessmentId`   |
| assessmentTargetTypes          | The assessed target database types.                                    | `assessmentTargetType` |
| breakingChangesCounts          | The number of breaking changes found.                                  | `breakingChangesCount` |
| compatibilityLevels            | The compatibility levels of the database.                              | `compatibilityLevel`   |
| databaseNames                  | The database names.                                                    | `databaseName`   |
| databaseSizeInMBs              | The sizes of the databases.                                            | `databaseSizeInMB`|
| enqueueTimes                   | The list of times the message was enqueued.                            | `enqueueTime`    |
| extendedInfos                  | The extended properties of all the database.                           | `extendedInfo`   |
| instanceIds                    | The database server instance Ids.                                      | `instanceId`     |
| isReadyForMigrations           | The values indicating whether the database is ready for migration.     | `isReadyForMigration` |
| lastAssessedTimes              | The time when the databases were last assessed.                        | `lastAssessedTime`|
| lastUpdatedTimes               | The time of the last modifications of the database details.            | `lastUpdatedTime`|
| migrationBlockersCounts        | The number of blocking changes found.                                  | `migrationBlockersCount` |
| solutionNames                  | The names of the solution that sent the data.                          | `solutionName`   |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through Migrate Project Databases by their names.

```ruby
azure_migrate_project_databases(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_DB_project').names.each do |name|
  describe azure_migrate_project_database(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_DB_project', name: name) do
    it { should exist }
  end
end
```
### Test that there are Migrate Project Databases that are ready for migration.

```ruby
describe azure_migrate_project_database(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_DB_project').where{ isReadyForMigration.include?(true) } do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Migrate Project Databases are present in the project and in the resource group
describe azure_migrate_project_database(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_DB_project') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Migrate Project Databases in the project and in the resource group
describe azure_migrate_project_database(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_DB_project') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.