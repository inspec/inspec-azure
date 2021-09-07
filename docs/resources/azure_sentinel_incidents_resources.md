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
| workspace_name | Azure Factory Name for which sentinel_incident are being retrived.|

## Properties

| Property        | Description                                            | Filter Criteria<superscript>*</superscript> |
  |-----------------|---------------------------------------------------------|-----------------|
| names           | A list of the unique resource names.                    | `name`          |
| ids             | A list of sentinel_incident IDs .                                | `id`            |
| properties      | A list of properties for the resource                   | `properties`          |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test if any sentinel_incident exist in the resource group

  ```ruby
  describe azure_sentinel_incidents_resources(resource_group: 'example', workspace_name: 'fn') do
    it { should exist }
    its('names') { should include 'sentinel_incident_name' }
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