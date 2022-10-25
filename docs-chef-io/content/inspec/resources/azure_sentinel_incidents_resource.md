+++
title = "azure_sentinel_incidents_resource Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_sentinel_incidents_resource"
identifier = "inspec/resources/azure/azure_sentinel_incidents_resource Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_sentinel_incidents_resource` InSpec audit resource to test the properties of an Azure Azure Sentinel incident.

## Azure Rest API Version, Endpoint, And HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used. For more information, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md" >}}).

Unless defined, the `azure_cloud` global endpoint and default values for the HTTP client will be used. For more information, refer to the resource pack [README](https://github.com/inspec/inspec-azure/blob/main/README.md). For API-related info : [`Azure Azure Sentinel incident  Docs`](https://docs.microsoft.com/en-us/rest/api/securityinsights/preview/incidents/get).

## Installation

{{% inspec_azure_install %}}

## Syntax

`resource_group` and `incident_id`, and `workspace_name` are required parameters.

```ruby
describe azure_sentinel_incidents_resource(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', incident_id: 'INCIDENT_ID') do
  #...
end
```

## Parameters

`resource_group`
: Azure resource group where the targeted resource resides.

`workspace_name`
: Name for the workspace where you want to create your Azure Sentinel incident.

`incident_id`
: The Azure Sentinel incident name.

All the parameter sets need be provided for a valid query are `resource_group` , `workspace_name`, and `incident_id`

## Properties

`name`
: Name of the Azure resource to test.

`id`
: The Azure Sentinel incident type.

`properties`
: The Properties of the resource.

`properties.severity`
: The severity of the incident.

`properties.status`
: The status of the incident.

`properties.owner.email`
: The user's email the incident is assigned to.

`properties.owner.userPrincipalName`
: The user's principal name the incident is assigned to.

`properties.owner.assignedTo`
: The user's name the incident is assigned to.

## Examples

### Test the properties of an incident

```ruby
describe azure_sentinel_incidents_resource(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', incident_id: 'INCIDENT_ID') do
  it { should exist }
  its('name') { should eq 'AZURE_RESOURCE_NAME' }
  its('type') { should eq 'Microsoft.SecurityInsights/Incidents' }
  its('properties.severity') { should eq 'Informational' }
  its('properties.status') { should eq 'New' }
  its('properties.owner.email') { should eq 'OWNER_EMAIL' }
  its('properties.owner.userPrincipalName') { should eq 'PRINCIPAL_NAME' }
  its('properties.owner.assignedTo') { should eq 'OWNER_NAME' }
end
```

### Test that an Azure sentinel incident exists

```ruby
describe azure_sentinel_incidents_resource(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', incident_id: 'INCIDENT_ID') do
  it { should exist }
end
```

### Test that an Azure sentinel incident does not exist

  ```ruby
  describe azure_sentinel_incidents_resource(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', incident_id: 'INCIDENT_ID') do
    it { should_not exist }
  end
  ```

### Test properties of a sentinel_incident

  ```ruby
  describe azure_sentinel_incidents_resource(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', incident_id: 'INCIDENT_ID') do
    its('name') { should eq 'INCIDENT_ID' }
  end
  ```

## Azure Permissions

{{% azure_permissions_service_principal role="contributor" %}}
