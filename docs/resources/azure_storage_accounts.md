---
title: About the azure_storage_accounts Resource
platform: azure
---

# azure_storage_accounts

Use the `azure_storage_accounts` InSpec audit resource to test properties and configuration of Azure Storage Accounts.

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

The `resource_group` must be given as a parameter.
```ruby
describe azurerm_storage_accounts(resource_group: 'rg') do
  its('names') { should include 'mysa'}
end
```
## Parameters

| Name                           | Description                                                                          |
|--------------------------------|--------------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`        |

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| names         | A list of names of all the resources being interrogated.                             | `name`          |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Check If a Specific Storage Account Exists
```ruby
describe azurerm_storage_accounts(resource_group: 'rg') do
  its('names') { should include('mysa') }
end
```
### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
# If we expect at least one account to exisit in a resource group
describe azurerm_storage_accounts(resource_group: 'rg') do
  it { should exist }
end

# If we expect no storage accounts to exist in a resource group
describe azurerm_storage_accounts(resource_group: 'rg') do
  it { should_not exist }
end

```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
