+++
title = "azure_sentinel_incidents_resources Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_sentinel_incidents_resources"
identifier = "inspec/resources/azure/azure_sentinel_incidents_resources Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_sentinel_incidents_resources` InSpec audit resource to test the properties of Azure Sentinel incidents for a resource group or the entire subscription.

## Azure Rest API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` can be defined as a resource parameter.
If not provided, the latest version is used.

For more information, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md" >}}).

Unless defined, the `azure_cloud` global endpoint and default values for the HTTP client are used. For more information, refer to the resource pack [README](https://github.com/inspec/inspec-azure/blob/main/README.md).

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_sentinel_incidents_resources` resource block returns all Azure sentinel incidents, either within a resource group (if provided) or an entire Subscription.

```ruby
describe azure_sentinel_incidents_resources(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME') do
  #...
end
```

The `resource_group` and `workspace_name` are required parameters.

## Parameters

`resource_group`
: Azure resource group where the targeted resource resides.

`workspace_name`
: Azure Workspace Name for which Azure Sentinel incidents are being retrieved.

## Properties

`names`
: A list of the unique resource names.

: **Field**: `name`

`ids`
: A list of Azure Sentinel incident IDs.

: **Field**: `id`

`properties`
: A list of properties for the resource.

: **Field**: `properties`

`descriptions`
: A list of descriptions for each resource.

: **Field**: `description`

`severities`
: The severity of the incident.

: **Field**: `severity`

`statuses`
: The status of the incident.

: **Field**: `status`

`owner_emails`
: The email of the user the incident is assigned.

: **Field**: `owner_email`

`owner_userPrincipalNames`
: The user principal name of the user the incident is assigned.

: **Field**: `owner_userPrincipalName`

`owner_assignedTos`
: The name of the user the incident is assigned.

: **Field**: `owner_assignedTo`

{{% inspec_filter_table %}}

## Examples

### Tests properties of incidents in a resource group

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

### Tests if any Azure Sentinel Incident exists in a resource group

```ruby
describe azure_sentinel_incidents_resources(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME') do
  it { should exist }
end
```

### Tests there are not any Azure Sentinel incidents in a resource group

```ruby
#Should not exist if no Azure Sentinel incidents are in the resource group.**

describe azure_sentinel_incidents_resources(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="contributor" %}}
