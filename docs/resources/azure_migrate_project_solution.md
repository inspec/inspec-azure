---
title: About the azure_migrate_project_solution Resource
platform: azure
---

# azure_migrate_project_solution

Use the `azure_migrate_project_solution` InSpec audit resource to test the properties related to an Azure Migrate Project Solution.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter. If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`name` and `resource_group` are required parameters.

```ruby
describe azure_migrate_project_solution(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME', name: 'ZONEA_ASSESSMENT_NAME') do
  it                                      { should exist }
  its('name')                             { should cmp 'ZONEA_ASSESSMENT_NAME' }
  its('type')                             { should cmp 'Microsoft.Migrate/MigrateProjects/Solutions' }
end
```

```ruby
describe azure_migrate_project_solution(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME', name: 'ZONEA_ASSESSMENT_NAME') do
  it  { should exist }
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Migrate project solution to test.                              |
| resource_group | Azure resource group that the targeted resource resides in.                      |
| project_name   | Azure Migrate project.                                                           |

The parameter set should be provided for a valid query:

- `resource_group`, `project_name`, and `name`.

## Properties

| Property                      | Description                                                      |
|-------------------------------|------------------------------------------------------------------|
| id                            | Path reference to the project solution.                          |
| name                          | Unique name of the project solution.                             |
| type                          | Object type. `Microsoft.Migrate/MigrateProjects/Solutions`       |
| eTag                          | For optimistic concurrency control.                              |
| properties                    | Properties of the project Solution.                              |
| properties.cleanupState       | The cleanup state of the solution.                               |
| properties.details            | The details of the solution.                                     |
| properties.summary            | The summary of the solution.                                     |
| properties.purpose            | The purpose of the solution.                                     |

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/migrate/projects/solutions/get-solution) for other properties available. Any attribute in the response is accessed with the key names separated by dots (`.`).

## Examples

### Test that the migrate project solution is defined for assessment

```ruby
describe azure_migrate_project_solution(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME', name: 'ZONEA_ASSESSMENT_NAME') do
  its('properties.purpose') { should eq 'ASSESSMENT' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If a Migrate Project Solution is found, it will exist
describe azure_migrate_project_solution(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME', name: 'ZONEA_ASSESSMENT_NAME') do
  it { should exist }
end

# if Migrate Project Solution are not found, it will not exist
describe azure_migrate_project_solution(resource_group: 'RESOURCE_GROUP', project_name: 'PROJECT_NAME', name: 'ZONEA_ASSESSMENT_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
