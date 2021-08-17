---
title: About the azure_migrate_assessment_groups Resource
platform: azure
---

# azure_migrate_assessment_groups

Use the `azure_migrate_assessment_groups` InSpec audit resource to test properties related to all Azure Migrate Assessment Groups within a project.

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

An `azure_migrate_assessment_groups` resource block returns all Azure Migrate Assessment Groups within a project.

```ruby
describe azure_migrate_assessment_groups(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project') do
  #...
end
```

## Parameters
| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| project_name   | Azure Migrate Assessment Project.                                                |

The parameter set should be provided for a valid query:
- `resource_group` and `project_name`

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|--------------------|
| ids                            | Path reference to all the groups.                                      | `id`               |
| names                          | Unique names for all groups.                                           | `name`             |
| types                          | Type of the objects.                                                   | `type`             |
| eTags                          | A list of eTags for all the groups.                                    | `eTag`             |
| properties                     | A list of Properties for all the groups.                               | `properties`       |
| areAssessmentsRunnings         | A list of boolean describing the assessment run state                  | `areAssessmentsRunning` |
| assessments                    | List of References to Assessments created on this group.               | `assessments`      |
| createdTimestamps              | List of creation times of the groups.                                  | `createdTimestamp` |
| groupStatuses                  | List of creation status of the groups.                                 | `groupStatus`      |
| groupTypes                     | List of group types.                                                   | `groupType`        |
| machineCounts                  | List of machine counts.                                                | `machineCount`     |
| updatedTimestamps              | List of updated timestamps of the groups.                              | `updatedTimestamp` |


<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/migrate/assessment/groups/list-by-project) for the complete list of properties available.

## Examples

### Loop through Migrate Assessment Groups by their names.

```ruby
azure_migrate_assessment_groups(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project').names.each do |name|
  describe azure_migrate_assessment_group(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project', name: name) do
    it { should exist }
  end
end
```
### Test that there are Migrate Assessment Groups for which the assessments are running 

```ruby
describe azure_migrate_assessment_groups(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project').where(areAssessmentsRunning: true) do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Migrate Assessment Groups are present in the project
describe azure_migrate_assessment_groups(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Migrate Assessment Groups in the project
describe azure_migrate_assessment_groups(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.