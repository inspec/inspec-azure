---
title: About the azure_migrate_project_events Resource
platform: azure
---

# azure_migrate_project_events

Use the `azure_migrate_project_events` InSpec audit resource to test properties related to all Azure Migrate Project Events within a project.

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

An `azure_migrate_project_events` resource block returns all Azure Migrate Project Events within a project.

```ruby
describe azure_migrate_project_events(resource_group: 'migrate_vms', project_name: 'zoneA_migrate_project') do
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
| ids                            | Path reference to the Project Events.                                  | `id`             |
| names                          | Unique names for all Project Events.                                   | `name`           |
| types                          | Type of the objects.                                                   | `type`           |
| properties                     | A list of Properties for all the Project Events.                       | `properties`     |
| instanceTypes                  | The Instance types.                                                    | `instanceType`   |
| machines                       | The machines for which the error is being reported.                    | `machine`        |
| errorCodes                     | The error codes.                                                       | `errorCode`      |
| errorMessages                  | The error messages.                                                    | `errorMessage`   |
| recommendations                | The recommendations for the error.                                     | `recommendation` |
| possibleCauses                 | The possible causes for the error.                                     | `possibleCause`  |
| solutions                      | The solutions for which the error is being reported.                   | `solution`       |
| clientRequestIds               | The client request Ids of the payload for which the event is being reported.| `clientRequestId` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
For more details on the available properties please refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/migrate/projects/events/enumerate-events)

## Examples

### Loop through Migrate Project Events by their names.

```ruby
azure_migrate_project_events(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_project').names.each do |name|
  describe azure_migrate_project_event(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_project', name: name) do
    it { should exist }
  end
end
```
### Test that there are Migrate Project Events for Databases.

```ruby
describe azure_migrate_project_events(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_project').where(instanceType: 'Databases') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Migrate Project Events are present in the project and in the resource group
describe azure_migrate_project_events(resource_group: 'migrate_vms', project_name: 'zoneA_migrate_project') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Migrate Project Events in the project and in the resource group
describe azure_migrate_project_events(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_project') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.