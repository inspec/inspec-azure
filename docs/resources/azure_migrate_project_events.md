---
title: About the azure_migrate_project_events Resource
platform: azure
---

# azure_migrate_project_events

Use the `azure_migrate_project_events` InSpec audit resource to test the properties related to all Azure Migrate project events within a project.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter. If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_migrate_project_events` resource block returns all Azure Migrate project events within a project.

```ruby
describe azure_migrate_project_events(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME') do
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
| ids                            | Path reference to the project events.                                  | `id`             |
| names                          | Unique names for all project events.                                   | `name`           |
| types                          | Type of the objects.                                                   | `type`           |
| properties                     | A list of properties for all the project events.                       | `properties`     |
| instanceTypes                  | The instance types.                                                    | `instanceType`   |
| machines                       | The machines for which the error is reported.                          | `machine`        |
| errorCodes                     | The error codes.                                                       | `errorCode`      |
| errorMessages                  | The error messages.                                                    | `errorMessage`   |
| recommendations                | The recommendations for the error.                                     | `recommendation` |
| possibleCauses                 | The possible causes for the error.                                     | `possibleCause`  |
| solutions                      | The solutions for which the error is reported.                         | `solution`       |
| clientRequestIds               | The client request Ids of the payload for which the event is reported. | `clientRequestId` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

For more details on the available properties, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/migrate/projects/events/enumerate-events).

## Examples

### Loop through migrate project events by their names

```ruby
azure_migrate_project_events(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME').names.each do |name|
  describe azure_migrate_project_event(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME', name: name) do
    it { should exist }
  end
end
```

### Test that there are migrate project events for databases

```ruby
describe azure_migrate_project_events(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME').where(instanceType: 'Databases') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist, if no migrate project events are present in the project and in the resource group
describe azure_migrate_project_events(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME') do
  it { should_not exist }
end
# Should exist, if the filter returns at least one migrate project events in the project and in the resource group
describe azure_migrate_project_events(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_project') do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
