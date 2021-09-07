---
title: About the azure_sentinel_incidents_resource Resource
platform: azure
  ---

# azure_sentinel_incidents_resource

Use the `azure_sentinel_incidents_resource` InSpec audit resource to test properties of an Azure sentinel_incident.

## Azure REST API version, endpoint, and HTTP client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).
For api related info : [`Azure sentinel_incident Docs`](https://docs.microsoft.com/en-us/rest/api/securityinsights/incidents/get).


## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group` and `incident_id`, `workspace_name` must be given as parameters.

  ```ruby
  describe azure_sentinel_incidents_resource(resource_group: resource_group, workspace_name: workspace_name, incident_id: incident_id) do
    
  end
  ```

## Parameters

| Name                           | Description                                                                       |
  |--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| workspace_name                           | Name for the data factory that you want to create your sentinel_incident in..                                                                 |
| incident_id                 | The sentinel_incident Name. |

All the parameter sets needs be provided for a valid query:
- `resource_group` , `workspace_name` and `incident_id`
## Properties

| Name                           | Description                                                                      |
  |--------------------------------|----------------------------------------------------------------------------------|
| name                           | Name of the Azure resource to test. `MyDf`                                       |
| id                             | The sentinel_incident type.                                                 |
| properties                     | The Properties of the Resource.                                | 
| properties.severity | The severity of the incident | `properties.severity` |
| properties.status| The status of the incident | `properties.status` |
| properties.owner.email | The email of the user the incident is assigned to. | `properties.owner.email` |
| properties.owner.userPrincipalName| The user principal name of the user the incident is assigned to. | `properties.owner.userPrincipalName` |
| properties.owner.assignedTo | The name of the user the incident is assigned to. | `properties.owner.assignedTo` |

## Examples

### Test if properties matches

```ruby
    describe azure_sentinel_incidents_resource(resource_group: resource_group, workspace_name: workspace_name, incident_id: incident_id) do
        it { should exist }
        its('name') { should eq '0367ce89-78ad-4009-8d90-399fad24aabf' }
        its('type') { should eq 'Microsoft.SecurityInsights/Incidents' }
        its('properties.severity') { should eq 'Informational' }
        its('properties.status') { should eq 'New' }
        its('properties.owner.email') { should eq 'owner_email' }
        its('properties.owner.userPrincipalName') { should eq 'samir.anand_progress.com#EXT#@getchef.onmicrosoft.com' }
        its('properties.owner.assignedTo') { should eq 'owner_name' }
    end
```


### Test that a sentinel_incident exists

  ```ruby
  describe azure_sentinel_incidents_resource(resource_group: resource_group, workspace_name: workspace_name, incident_id: incident_id) do
    it { should exist }
  end
  ```

### Test that a sentinel_incident does not exist

  ```ruby
  describe azure_sentinel_incidents_resource(resource_group: resource_group, workspace_name: workspace_name, incident_id: 'should not exit') do
    it { should_not exist }
  end
  ```

### Test properties of a sentinel_incident

  ```ruby
  describe azure_sentinel_incidents_resource(resource_group: resource_group, workspace_name: workspace_name, incident_id: 'incident_id1') do
    its('name') { should eq 'incident_id1' }
  end
  ```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.