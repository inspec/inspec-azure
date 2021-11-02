---
title: About the azure_sentinel_incidents_resources Resource
platform: azure
  ---

# azure_sentinel_incidents_resources

Use the `azure_sentinel_incidents_resources` InSpec audit resource to test properties of Azure Sentinel incidents for a resource group or the entire subscription.

## Azure Rest API Version, Endpoint, And HTTP Client Parameters

This resource interacts with API versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_sentinel_incidents_resources` resource block returns all Azure sentinel incident, either within a resource group (if provided), or within an entire Subscription.

```ruby
describe azure_sentinel_incidents_resources(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME') do
  #...
end
```

`resource_group` and `workspace_name` are required parameters.


## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in.  |
| workspace_name | Azure Workspace Name for which Azure Sentinel incident are being retrieved.|

## Properties

| Property        | Description                                            | Filter Criteria<superscript>*</superscript> |
|-----------------|---------------------------------------------------------|-----------------|
| names           | A list of the unique resource names.                    | `name`          |
| ids             | A list of Azure Sentinel incident IDs .                       | `id`            |
| properties      | A list of properties for the resource                   | `properties`          |
| descriptions      | A list of descriptions for each resource              | `description`          |
| severities | The severity of the incident                                 | `severity` |
| statuses| The status of the incident                                      | `status` |
| owner_emails | The email of the user the incident is assigned to.         | `owner_email` |
| owner_userPrincipalNames| The user principal name of the user the incident is assigned to. | `owner_userPrincipalName` |
| owner_assignedTos | The name of the user the incident is assigned to. | `owner_assignedTo` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test Properties of Incidents in a Resource Group

```ruby
describe azure_sentinel_incidents_resource(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME') do
  it { should exist }
  its('names') { should include 'RESOURCE_NAME' }
  its('types') { should include 'Microsoft.SecurityInsights/Incidents' }
  its('titles') { should include 'TITLE' }
  its('descriptions') { should include 'DESCRIPTION_TEXT' }
  its('severities') { should include 'Informational' }
  its('statuses') { should include 'New' }
  its('owner_emails') { should include 'EMAIL_ADDRESS' }
  its('owner_userPrincipalNames') { should include 'PRINCIPAL_NAME' }
  its('owner_assignedTos') { should include 'ASSIGNED_TO_NAME' }
end
```

### Test If Any Azure Sentinel Incident Exists in a Resource Group

```ruby
describe azure_sentinel_incidents_resources(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME') do
  it { should exist }
end
```

### Test That There Aren't Any Azure Sentinel Incident in a Resource Group

```ruby
# Should not exist if no Azure Sentinel incident are in the resource group
describe azure_sentinel_incidents_resources(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
