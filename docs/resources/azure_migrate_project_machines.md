---
title: About the azure_migrate_project_machines Resource
platform: azure
---

# azure_migrate_project_machines

Use the `azure_migrate_project_machines` InSpec audit resource to test properties related to all Azure Migrate Project Machines within a project.

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

An `azure_migrate_project_machines` resource block returns all Azure Migrate Project Machines within a project.

```ruby
describe azure_migrate_project_machines(resource_group: 'migrate_vms', project_name: 'zoneA_migrate_DB_project') do
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
| ids                            | Path reference to the Project Machines.                                | `id`             |
| names                          | Unique names for all Project Machines.                                 | `name`           |
| types                          | Type of the objects.                                                   | `type`           |
| properties                     | A list of Properties for all the Project Machines.                     | `properties`     |
| discoveryData                  | The discovery details of all the machine published by various sources. | `discoveryData`  |
| assessmentData                 | The assessment details of all the machine published by various sources.| `assessmentData` |
| migrationData                  | The migration details of all the machine published by various sources. | `migrationData`  |
| lastUpdatedTimes               | The times of the last modification of all the machines.                | `lastUpdatedTime`|

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
For more details on the available properties please refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/migrate/projects/machines/enumerate-machines)

## Examples

### Loop through Migrate Project Machines by their names.

```ruby
azure_migrate_project_machines(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_DB_project').names.each do |name|
  describe azure_migrate_project_machine(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_DB_project', name: name) do
    it { should exist }
  end
end
```
### Test that there are Migrate Project Machines with os type windows.

```ruby
describe azure_migrate_project_machines(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_DB_project').where{ discoveryData.detect{ |data| data[:osType] == 'windowsguest' } } do
  it { should exist }
end
```

### Test Migrate Project Machines with BIOS boot type

```ruby
describe azure_migrate_project_machines(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_DB_project').where{ discoveryData.detect{ |data| data[:extendedInfo][:bootType] == 'BIOS' } } do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Migrate Project Machines are present in the project and in the resource group
describe azure_migrate_project_machines(resource_group: 'migrate_vms', project_name: 'zoneA_migrate_project') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Migrate Project Machines in the project and in the resource group
describe azure_migrate_project_machines(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_project') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.