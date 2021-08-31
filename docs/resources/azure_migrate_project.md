---
title: About the azure_migrate_project Resource
platform: azure
---

# azure_migrate_project

Use the `azure_migrate_project` InSpec audit resource to test properties related to an Azure Migrate Project.

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
describe azure_migrate_project(resource_group: 'migrated_vms', name: 'zoneA_migrate_project') do
  it                                      { should exist }
  its('name')                             { should eq 'zoneA_migrate_project' }
  its('type')                             { should eq 'Microsoft.Migrate/MigrateProjects' }
end
```

```ruby
describe azure_migrate_project(resource_group: 'migrated_vms', name: 'zoneA_migrate_project') do
  it  { should exist }
end
```
## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Migrate Project to test.                                   |
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |

The parameter set should be provided for a valid query:
- `resource_group` and `name`

## Properties

| Property                 | Description                                                      |
|--------------------------|------------------------------------------------------------------|
| id                       | Path reference to the Migrate Project.                           |
| eTag                     | The eTag for concurrency control.                                |
| name                     | Unique name of an Migrate Project.                               |
| type                     | Type of the object. `Microsoft.Migrate/MigrateProject`           |
| properties               | The nested properties.                                           |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/migrate/projects/migrate-projects/get-migrate-project) for other properties available.
Any attribute in the response nested within properties may be accessed with the key names separated by dots (`.`) and attributes nested in the assessmentData
is pluralized and listed as collection.

## Examples

### Test that the Migrate Project has Server Instances.

```ruby
describe azure_migrate_project(resource_group: 'migrated_vms', name: 'zoneA_migrate_project') do
  its('properties.summary.servers.instanceType') { should eq 'Servers' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a Migrate Project is found it will exist
describe azure_migrate_project(resource_group: 'migrated_vms', name: 'sql_db') do
  it { should exist }
end
# if Migrate Project is not found it will not exist
describe azure_migrate_project(resource_group: 'migrated_vms', name: 'sql_db') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.