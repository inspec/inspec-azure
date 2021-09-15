---
title: About the azure_migrate_assessment_projects Resource
platform: azure
---

# azure_migrate_assessment_projects

Use the `azure_migrate_assessment_projects` InSpec audit resource to test the properties related to all Azure Migrate assessment projects within a subscription.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client are used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_migrate_assessment_projects` resource block returns all Azure Migrate projects within a subscription.

```ruby
describe azure_migrate_assessment_projects do
  #...
end
```

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | Path reference to the projects.                                        | `id`             |
| names                          | Name of the projects.                                                  | `name`           |
| types                          | Type of the project.                                                   | `type`           |
| eTags                          | A list of eTags for all the assessments.                               | `eTag`           |
| locations                      | Azure locations in which project is created.                           | `location`       |
| tags                           | A list of Tags provided by Azure Tagging service.                      | `tags`           |
| properties                     | A list of Properties for all the projects.                             | `properties`     |
| assessmentSolutionIds          | Assessment solution ARM ids tracked by `Microsoft.Migrate/migrateProjects`.| `assessmentSolutionId`  |
| createdTimestamps              | Times when this project was created. Date-Time represented in ISO-8601 format.| `createdTimestamp`|
| customerStorageAccountArmIds   | The ARM ids of the storage account used for interactions when public access is disabled.| `customerStorageAccountArmId` |
| customerWorkspaceIds           | The ARM ids of service map workspace created by customer.              | `customerWorkspaceId` |
| customerWorkspaceLocations     | Locations of service map workspace created by customer.                | `customerWorkspaceLocation`|
| lastAssessmentTimestamps       | Times when last assessment is created.                                 | `lastAssessmentTimestamp` |
| numberOfAssessments            | Number of assessments created in the project.                          | `numberOfAssessments`|
| numberOfGroups                 | Number of groups created in all the projects.                          | `numberOfGroups`  |
| numberOfMachines               | Number of machines in all the projects.                                | `numberOfMachines`|
| privateEndpointConnections     | The list of private endpoint connections to the projects.              | `privateEndpointConnections` |
| projectStatuses                | Assessment project statuses.                                           | `projectStatus`   |
| provisioningStates             | Provisioning states of all the projects.                               | `provisioningState`|
| publicNetworkAccesses          | Public Network Access for all the projects.                            | `publicNetworkAccess`|
| serviceEndpoints               | Service Endpoints of all the projects.                                 | `serviceEndpoint` |
| updatedTimestamps              | Times when this project is last updated.                               | `updatedTimestamp`|

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through migrate assessment projects by their names

```ruby
azure_migrate_assessment_projects.names.each do |name|
  describe azure_migrate_assessment_project(resource_group: 'RESOURCE_GROUP', name: name) do
    it { should exist }
  end
end
```

### Test to ensure that migrate assessment projects in West Europe location

```ruby
describe azure_migrate_assessment_projects.where(location: 'westeurope') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Migrate Assessment Projects are present in the subscription
describe azure_migrate_assessment_projects do
  it { should_not exist }
end

# Should exist if the filter returns at least one Migrate Assessment Projects in the subscription
describe azure_migrate_assessment_projects do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
