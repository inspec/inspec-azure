---
title: About the azure_migrate_project_solutions Resource
platform: azure
---

# azure_migrate_project_solutions

Use the `azure_migrate_project_solutions` InSpec audit resource to test the properties related to all Azure Migrate project solutions within a project.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with api versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_migrate_project_solutions` resource block returns all Azure Migrate project solutions within a project.

```ruby
describe azure_migrate_project_solutions(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME') do
  #...
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| resource_group | Azure resource group that the targeted resource resides in.                      |
| project_name   | Azure Migrate Project.                                                           |

The parameter set should be provided for a valid query:

- `resource_group` and `project_name`.

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | Path reference to the project solutions.                               | `id`             |
| names                          | Unique names for all project solutions.                                | `name`           |
| types                          | Type of the objects.                                                   | `type`           |
| eTags                          | A list of eTags for all the Project Solutions.                         | `eTag`           |
| properties                     | A list of Properties for all the Project Solutions.                    | `properties`     |
| tools                          | The tool used in all the solutions.                                    | `tool`           |
| purposes                       | The purpose of all the solutions.                                      | `purpose`        |
| goals                          | The goals of all the solutions.                                        | `goal`           |
| statuses                       | The current status of all the solutions.                               | `status`         |
| cleanupStates                  | The cleanup states of all the solutions.                               | `cleanupState`   |
| summaries                      | The summary of all the solutions.                                      | `summary`        |
| details                        | The details of all the solutions.                                      | `details`        |
| instanceTypes                  | The Instance types.                                                    | `instanceType`   |
| databasesAssessedCounts        | The count of databases assessed.                                       | `databasesAssessedCount` |
| databaseInstancesAssessedCounts| The count of database instances assessed.                              | `databaseInstancesAssessedCount` |
| migrationReadyCounts           | The count of databases ready for migration.                            | `migrationReadyCount` |
| groupCounts                    | The count of groups reported by all the solutions.                     | `groupCount`     |
| assessmentCounts               | The count of assessments reported by all the solutions.                | `assessmentCount`|
| extendedDetails                | The extended details reported by all the solutions.                    | `extendedDetails`|

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md). Also for further reference of the properties please refer [Azure Documentation](https://docs.microsoft.com/en-us/rest/api/migrate/projects/solutions/enumerate-solutions)

## Examples

### Loop through migrate project solutions by their names

```ruby
azure_migrate_project_solutions(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME').names.each do |name|
  describe azure_migrate_project_solution(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME', name: name) do
    it { should exist }
  end
end
```

### Test to ensure the migrate project solutions for assessment

```ruby
describe azure_migrate_project_solutions(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME').where(purpose: 'Assessment') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Migrate Project Solutions are present in the project and in the resource group
describe azure_migrate_project_solutions(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Migrate Project Solutions in the project and in the resource group
describe azure_migrate_project_solutions(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME') do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
