---
title: About the azure_migrate_assessment_project Resource
platform: azure
---

# azure_migrate_assessment_project

Use the `azure_migrate_assessment_project` InSpec audit resource to test the properties related to an Azure Migrate Assessment Project.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`name` and `resource_group` are required parameters.

```ruby
describe azure_migrate_assessment_project(resource_group: 'MIGRATED_VMS', name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT') do
  it                                      { should exist }
  its('name')                             { should cmp 'ZONEA_MIGRATE_ASSESSMENT_PROJECT' }
  its('type')                             { should cmp 'Microsoft.Migrate/assessmentprojects' }
end
```

```ruby
describe azure_migrate_assessment_project(resource_group: 'MIGRATED_VMS', name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT') do
  it  { should exist }
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Migrate Assessment Project to test.                                   |
| resource_group | Azure resource group that the targeted project resides in. `MyResourceGroup`    |

The parameter set should be provided for a valid query:

- `resource_group` and `name`

## Properties

| Property                      | Description                                                      |
|-------------------------------|------------------------------------------------------------------|
| id                            | Path reference to the project.                                  |
| name                          | Name of the project.                                             |
| type                          | Type of the object. `Microsoft.Migrate/assessmentProjects`       |
| eTag                          | For optimistic concurrency control.                              |
| properties                    | Properties of the project.                                       |
| location                      | Azure location in which project is created.                      |
| properties.assessmentSolutionId | Assessment solution ARM id tracked by `Microsoft.Migrate/migrateProjects`.|
| properties.customerStorageAccountArmId| The ARM ID of the storage account used for interactions when public access is disabled.|
| properties.privateEndpointConnections | The list of private endpoint connections to the project. |
| properties.numberOfMachines   | Number of machines in the project.                               |
| tags                          | Tags provided by Azure Tagging service.                          |

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/migrate/assessment/projects/get) for other properties available. Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test that the Migrate Assessment Project has a minimum scalingFactor

```ruby
describe azure_migrate_assessment_project(resource_group: 'MIGRATED_VMS', name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT') do
  its('properties.numberOfGroups') { should eq 2 }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a Migrate Assessment Project is found, it will exist
describe azure_migrate_assessment_project(resource_group: 'MIGRATED_VMS', name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT') do
  it { should exist }
end

# if Migrate Assessment Project is not found, it will not exist
describe azure_migrate_assessment_project(resource_group: 'MIGRATED_VMS', name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
