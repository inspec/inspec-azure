---
title: About the azure_migrate_project_machines Resource
platform: azure
---

# azure_migrate_project_machines

Use the `azure_migrate_project_machines` InSpec audit resource to test the properties related to all Azure Migrate project machines within a project.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client are used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_migrate_project_machines` resource block returns all Azure Migrate project machines within a project.

```ruby
describe azure_migrate_project_machines(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME') do
  #...
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| resource_group | Azure resource group that the targeted resource resides in.                      |
| project_name   | Azure Migrate project name.                                                      |

The parameter set should be provided for a valid query:
- `resource_group` and `project_name`.

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | Path reference to the project machines.                                | `id`             |
| names                          | Unique names for all project machines.                                 | `name`           |
| types                          | Type of the objects.                                                   | `type`           |
| properties                     | A list of properties for all the project machines.                     | `properties`     |
| discoveryData                  | The discovery details of all the machine published by various sources. | `discoveryData`  |
| assessmentData                 | The assessment details of all the machine published by various sources.| `assessmentData` |
| migrationData                  | The migration details of all the machine published by various sources. | `migrationData`  |
| lastUpdatedTimes               | The times of the last modification of all the machines.                | `lastUpdatedTime`|

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md). For more details on the available properties please refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/migrate/projects/machines/enumerate-machines).

## Examples

### Loop through migrate project machines by their names

```ruby
azure_migrate_project_machines(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME').names.each do |name|
  describe azure_migrate_project_machine(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME', name: `NAME`) do
    it { should exist }
  end
end
```

### Test that there are migrate project machines with Windows OS

```ruby
describe azure_migrate_project_machines(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME').where{ discoveryData.detect{ |data| data[:osType] == 'windowsguest' } } do
  it { should exist }
end
```

### Test that the migrate project machines is of BIOS boot type

```ruby
describe azure_migrate_project_machines(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME').where{ discoveryData.detect{ |data| data[:extendedInfo][:bootType] == 'BIOS' } } do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist, if no migrate project machines are present in the project and in the resource group
describe azure_migrate_project_machines(resource_group: 'migrate_vms', project_name: 'zoneA_migrate_project') do
  it { should_not exist }
end
# Should exist, if the filter returns at least one migrate project machines in the project and in the resource group
describe azure_migrate_project_machines(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME') do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
