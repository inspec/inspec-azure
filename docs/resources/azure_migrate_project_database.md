---
title: About the azure_migrate_project_database Resource
platform: azure
---

# azure_migrate_project_database

Use the `azure_migrate_project_database` InSpec audit resource to test the properties related to an Azure Migrate Project Database.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`name` is a required parameter and `resource_group` is an optional parameter.

```ruby
describe azure_migrate_project_database(resource_group: 'MIGRATED_VMS', project_name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT', name: 'SQL_DB') do
  it                                      { should exist }
  its('name')                             { should eq 'SQL_DB' }
  its('type')                             { should eq 'Microsoft.Migrate/MigrateProjects/Databases' }
  its('solutionNames')                    { should include 'MIGRATEDBSOLUTION' }
end
```

```ruby
describe azure_migrate_project_database(resource_group: 'MIGRATED_VMS', project_name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT', name: 'SQL_DB') do
  it  { should exist }
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Migrate Project Database to test.                                   |
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| project_name   | Azure Migrate Assessment Project.                                                |

The parameter set should be provided for a valid query:

- `resource_group` and `project_name` and `name`

## Properties

| Property                      | Description                                                      |
|-------------------------------|------------------------------------------------------------------|
| id                            | Path reference to the Migrate Project Database.                  |
| name                          | Unique name of a Migrate Project Database.                      |
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

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/migrate/projects/databases/get-database) for other properties available. Any attribute in the response nested within properties is accessed with the key names separated by dots (`.`) and attributes nested in the assessmentData are pluralized and listed as a collection.

## Examples

### Test that Migrate Project Database has a SQL assessmentTargetType

```ruby
describe azure_migrate_project_database(resource_group: 'MIGRATED_VMS', project_name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT', name: 'SQL_DB') do
  its('assessmentTargetTypes') { should include 'SQL' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a Migrate Project Database is found, it will exist
describe azure_migrate_project_database(resource_group: 'MIGRATED_VMS', project_name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT', name: 'SQL_DB') do
  it { should exist }
end

# if Migrate Project Database is not found, it will not exist
describe azure_migrate_project_database(resource_group: 'MIGRATED_VMS', project_name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT', name: 'SQL_DB') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
