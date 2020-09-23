---
title: About the azure_storage_account_blob_containers Resource
platform: azure
---

# azure_storage_account_blob_containers

Use the `azure_storage_account_blob_containers` InSpec audit resource to test properties and configuration of Blob Containers within an Azure Storage Account.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used.
For more information, refer to the resource pack [README](../../README.md). 

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

The `resource_group`, and `storage_account_name` must be given as a parameter.
```ruby
describe azurerm_storage_account_blob_containers(resource_group: 'rg', storage_account_name: 'production') do
  its('names') { should include 'my-container'}
end
```
## Parameters

| Name                           | Description                                                                          |
|--------------------------------|--------------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`        |
| storage_account_name           | The name of the storage account within the specified resource group. `accountName`   |

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| ids           | A list of the unique resource ids.                                                   | `id`            |
| locations     | A list of locations for all the resources being interrogated.                        | `location`      |
| names         | A list of names of all the resources being interrogated.                             | `name`          |
| tags          | A list of `tag:value` pairs defined on the resources being interrogated.             | `tags`          |
| etags         | A list of etags defined on the resources.                                            | `etag`          |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Check If a Specific Container Exists
```ruby
describe azurerm_storage_account_blob_containers(resource_group: 'rg', storage_account_name: 'production') do
  its('names') { should include('my-container') }
end
```
### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
# If we expect at least one resource to exists on a specified account
describe azurerm_storage_account_blob_containers(resource_group: 'rg', storage_account_name: 'production') do
  it { should exist }
end

# If we expect not to exist any containers on a specified account
describe azurerm_storage_account_blob_containers(resource_group: 'rg', storage_account_name: 'production') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
