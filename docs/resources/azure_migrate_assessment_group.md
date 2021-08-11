---
title: About the azure_migrate_assessment_group Resource
platform: azure
---

# azure_migrate_assessment_group

Use the `azure_migrate_assessment_group` InSpec audit resource to test properties related to an Azure Migrate Assessment Group.

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
describe azure_migrate_assessment_group(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project', name: 'zoneA_machines_group') do
  it                                      { should exist }
  its('name')                             { should cmp 'zoneA_machines_migrate_assessment' }
  its('type')                             { should cmp 'Microsoft.Migrate/assessmentprojects/groups/assessments' }
end
```

```ruby
describe azure_migrate_assessment_group(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project', name: 'zoneA_machines_group') do
  it  { should exist }
end
```
## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Migrate Assessment Group to test.                                   |
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| project_name   | Azure Migrate Assessment Project.                                                |
| name           | Unique name of the group within a project.                                   |

The parameter set should be provided for a valid query:
- `resource_group` and `project_name` and `name`

## Properties

| Property                      | Description                                                      |
|-------------------------------|------------------------------------------------------------------|
| id                            | Path reference to the assessment.                                |
| name                          | Unique name of an assessment.                                    |
| type                          | Type of the object. `Microsoft.Migrate/assessmentProjects/groups` |
| eTag                          | For optimistic concurrency control.                              |
| properties                    | Properties of the assessment.                                    |


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/migrate/assessment/assessments/get) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test that the Migrate Assessment Group has a minimum scalingFactor.

```ruby
describe azure_migrate_assessment_group(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project', name: 'zoneA_machines_group') do
  its('properties.scalingFactor') { should eq 1.0 }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a Migrate Assessment Group is found it will exist
describe azure_migrate_assessment_group(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project', name: 'zoneA_machines_group') do
  it { should exist }
end
# if Migrate Assessment Group are not found it will not exist
describe azure_migrate_assessment_group(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project', name: 'zoneA_machines_group') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.