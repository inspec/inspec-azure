---
title: About the azure_sentinel_incidents_resource Resource
platform: azure
---

# azure_sentinel_incidents_resource

Use the `azure_sentinel_incidents_resource` InSpec audit resource to test properties of an Azure Azure Sentinel incident.

## Azure Rest API Version, Endpoint, And HTTP Client Parameters

This resource interacts with API versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).
For api related info : [`Azure Azure Sentinel incident  Docs`](https://docs.microsoft.com/en-us/rest/api/securityinsights/incidents/get).


## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group` and `incident_id`, `workspace_name` must be given as parameters.

```ruby
describe azure_sentinel_incidents_resource(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', incident_id: 'INCIDENT_ID') do
  #...
end
```

## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in.                       |
| workspace_name                 | Name for the workspace that you want to create your Azure Sentinel incident  in.  |
| incident_id                    | The Azure Sentinel incident name.                                                 |

All the parameter sets needs be provided for a valid query:
- `resource_group` , `workspace_name` and `incident_id`

## Properties

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| name                           | Name of the Azure resource to test.                                              |
| id                             | The Azure Sentinel incident  type.                                               |
| properties                     | The Properties of the Resource.                                                  |
| properties.severity | The severity of the incident.                                                               |
| properties.status| The status of the incident.                                                                    |
| properties.owner.email | The email of the user the incident is assigned to.                                       |
| properties.owner.userPrincipalName| The user principal name of the user the incident is assigned to.              |
| properties.owner.assignedTo | The name of the user the incident is assigned to.                                   |

## Examples

### Test The Properties of an Incident

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

### Test That An Azure Sentinel Incident Exists

```ruby
describe azure_sentinel_incidents_resource(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', incident_id: 'INCIDENT_ID') do
  it { should exist }
end
```

### Test That An Azure Sentinel Incident Does Not Exist

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

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
