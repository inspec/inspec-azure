---
title: About the azure_sentinel_incidents_resources Resource
platform: azure
  ---

# azure_sentinel_incidents_resources

Use the `azure_sentinel_incidents_resources` InSpec audit resource to test properties related to sentinel_incident for a resource group or the entire subscription.

## Azure REST API version, endpoint, and HTTP client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).
For api related info : [`Azure sentinel_incident Docs`](https://docs.microsoft.com/en-us/rest/api/securityinsights/incidents/list).
## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_sentinel_incidents_resources` resource block returns all Azure sentinel_incident, either within a Resource Group (if provided), or within an entire Subscription.

  ```ruby
  describe azure_sentinel_incidents_resources(resource_group: 'example', workspace_name: 'fn') do
    #...
  end
  ```
`resource_group` and `workspace_name` must be given as parameters.


## Parameters

| Name                           | Description                                                                       |
  |--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| workspace_name | Azure Workspace Name for which sentinel_incident are being retrived.|

## Properties

| Property        | Description                                            | Filter Criteria<superscript>*</superscript> |
  |-----------------|---------------------------------------------------------|-----------------|
| names           | A list of the unique resource names.                    | `name`          |
| ids             | A list of sentinel_incident IDs .                       | `id`            |
| properties      | A list of properties for the resource                   | `properties`          |
| descriptions      | A list of descriptions for each resource              | `description`          |
| severities | The severity of the incident                                 | `severity` |
| statuses| The status of the incident                                      | `status` |
| owner_emails | The email of the user the incident is assigned to.         | `owner_email` |
| owner_userPrincipalNames| The user principal name of the user the incident is assigned to. | `owner_userPrincipalName` |
| owner_assignedTos | The name of the user the incident is assigned to. | `owner_assignedTo` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test if properties matches

```ruby
    describe azure_sentinel_incidents_resource(resource_group: resource_group, workspace_name: 'workspace_name') do
      it { should exist }
      its('names') { should include '0367ce89-78ad-4009-8d90-399fad24aabf' }
      its('types') { should include 'Microsoft.SecurityInsights/Incidents' }
      its('titles') { should include 'test-ana' }
      its('descriptions') { should include 'test-rule' }
      its('severities') { should include 'Informational' }
      its('statuses') { should include 'New' }
      its('owner_emails') { should include 'mailid' }
      its('owner_userPrincipalNames') { should include 'mail#EXT#@getchef.onmicrosoft.com' }
      its('owner_assignedTos') { should include 'Name' }
    end
```

### Test if any sentinel_incident exist in the resource group

  ```ruby
  describe azure_sentinel_incidents_resources(resource_group: 'example', workspace_name: 'fn') do
    it { should exist }
  end
  ```
### Test that there aren't any sentinel_incident in a resource group

  ```ruby
  # Should not exist if no sentinel_incident are in the resource group
  describe azure_sentinel_incidents_resources(resource_group: 'example', workspace_name: 'fake') do
    it { should_not exist }
  end
  ```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
