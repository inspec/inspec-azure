---
title: About the azure_migrate_assessment Resource
platform: azure
---

# azure_migrate_assessment

Use the `azure_migrate_assessment` InSpec audit resource to test the properties related to Azure Migrate Assessments.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client are used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`name`, `resource_group`, `project_name` & `group_name` is a required parameter.

```ruby
describe azure_migrate_assessment(resource_group: 'MIGRATED_VMS', project_name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT', group_name: 'ZONEA_MACHINES_GROUP', NAME: 'ZONEA_MACHINES_MIGRATE_ASSESSMENT') do
  it                                      { should exist }
  its('name')                             { should cmp 'ZONEA_MACHINES_MIGRATE_ASSESSMENT' }
  its('type')                             { should cmp 'Microsoft.Migrate/assessmentprojects/groups/assessments' }
end
```

```ruby
describe azure_migrate_assessment(resource_group: 'MIGRATED_VMS', project_name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT', group_name: 'ZONEA_MACHINES_GROUP', name: 'ZONEA_MACHINES_MIGRATE_ASSESSMENT') do
  it  { should exist }
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Migrate Assessment to test.                                   |
| resource_group | Azure resource group where the targeted resource resides in. `MyResourceGroup`    |
| project_name   | Azure Migrate Assessment Project.                                                |
| group_name     | Unique name of a group within a project.                                         |

The parameter set should be provided for a valid query:

- `resource_group` and `project_name` and `group_name` and `name`

## Properties

| Property                      | Description                                                      |
|-------------------------------|------------------------------------------------------------------|
| id                            | Path reference to the assessment.                                |
| name                          | Unique name of an assessment.                                    |
| type                          | Object type. `Microsoft.Migrate/assessmentProjects/groups/assessments` |
| eTag                          | For optimistic concurrency control.                              |
| properties                    | Properties of the assessment.                                    |
| properties.azureDiskType      | Storage type selected for this disk.                             |
| properties.currency           | Currency to report prices in.                                    |
| properties.sizingCriterion    | Assessment sizing criterion.                                     |
| properties.reservedInstance   | Azure reserved instance.                                         |

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Refer to the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/migrate/assessment/assessments/get) for a full list of available properties. Access any attribute in the response by separating the key names with a period (`.`).

## Examples

### Test that the Migrate Assessments has a minimum scaling factor

```ruby
describe azure_migrate_assessment(resource_group: 'MIGRATED_VMS', project_name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT', group_name: 'ZONEA_MACHINES_GROUP', name: 'ZONEA_MACHINES_MIGRATE_ASSESSMENT') do
  its('properties.scalingFactor') { should eq 1.0 }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a Migrate Assessments is found, it will exist
describe azure_migrate_assessment(resource_group: 'MIGRATED_VMS', project_name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT', group_name: 'ZONEA_MACHINES_GROUP', name: 'ZONEA_MACHINES_MIGRATE_ASSESSMENT') do
  it { should exist }
end

# if Migrate Assessments are not found, it will not exist
describe azure_migrate_assessment(resource_group: 'MIGRATED_VMS', project_name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT', group_name: 'zONEA_MACHINES_GROUP', name: 'ZONEA_MACHINES_MIGRATE_ASSESSMENT') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
