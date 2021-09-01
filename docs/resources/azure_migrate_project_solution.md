---
title: About the azure_migrate_project_solution Resource
platform: azure
---

# azure_migrate_project_solution

Use the `azure_migrate_project_solution` InSpec audit resource to test properties related to an Azure Migrate Project Solution.

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

`name` and `resource_group` is a required parameter.

```ruby
describe azure_migrate_project_solution(resource_group: 'migrate_vms', project_name: 'zoneA_migrate_project', name: 'zoneA_machines_migrate_solution') do
  it                                      { should exist }
  its('name')                             { should cmp 'zoneA_machines_migrate_solution' }
  its('type')                             { should cmp 'Microsoft.Migrate/MigrateProjects/Solutions' }
end
```

```ruby
describe azure_migrate_project_solution(resource_group: 'migrate_vms', project_name: 'zoneA_migrate_project', name: 'zoneA_machines_migrate_solution') do
  it  { should exist }
end
```
## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Migrate Project Solution to test.                                   |
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| project_name   | Azure Migrate Project.                                                |

The parameter set should be provided for a valid query:
- `resource_group` and `project_name` and `name`

## Properties

| Property                      | Description                                                      |
|-------------------------------|------------------------------------------------------------------|
| id                            | Path reference to the Project Solution.                          |
| name                          | Unique name of the Project Solution.                             |
| type                          | Type of the object. `Microsoft.Migrate/MigrateProjects/Solutions`|
| eTag                          | For optimistic concurrency control.                              |
| properties                    | Properties of the project Solution.                              |
| properties.cleanupState       | The cleanup state of the solution.                               |
| properties.details            | The details of the solution.                                     |
| properties.summary            | The summary of the solution.                                     |
| properties.purpose            | The purpose of the solution.                                     |


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/migrate/projects/solutions/get-solution) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test that the Migrate Project Solution is defined for Assessment purpose.

```ruby
describe azure_migrate_project_solution(resource_group: 'migrate_vms', project_name: 'zoneA_migrate_project', name: 'zoneA_machines_migrate_solution') do
  its('properties.purpose') { should eq 'Assessment' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a Migrate Project Solution is found it will exist
describe azure_migrate_project_solution(resource_group: 'migrate_vms', project_name: 'zoneA_migrate_project', name: 'zoneA_machines_migrate_solution') do
  it { should exist }
end

# if Migrate Project Solution are not found it will not exist
describe azure_migrate_project_solution(resource_group: 'migrate_vms', project_name: 'zoneA_migrate_project', name: 'zoneA_machines_migrate_solution') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.