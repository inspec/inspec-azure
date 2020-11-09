---
title: About the azure_storage_account Resource
platform: azure
---

# azure_storage_account

Use the `azure_storage_account` InSpec audit resource to test properties related to a Azure Storage Account.

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

`resource_group` and `name` must be given as a parameter.
```ruby
describe azure_storage_account(resource_group: 'rg', name: 'sa')  do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                          |
|--------------------------------|--------------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`        |
| name           | The name of the storage account within the specified resource group. `accountName`   |


## Properties

| Property                              | Description |
|---------------------------------------|-------------|
| has_encryption_enabled? | Indicates whether the storage account has encryption enabled|

Storage account properties documentation [Storage Account API](https://docs.microsoft.com/en-us/rest/api/storagerp/srp_json_get_storage_account_properties#response-body-version-2016-01-01-and-later)

For properties applicable to all resources, such as `type`, `tags`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

## Examples

### Test if encryption is enabled
```ruby
describe azure_storage_account(resource_group: 'rg', name: 'mysa') do
  it { should have_encryption_enabled }
end
```

```
### Loop through Resources
```ruby
azure_storage_accounts(resource_group: 'rg').name.each do |n|
  describe azure_storage_account(resource_group: 'rg', name: n) do
    it { should have_encryption_enabled }
  end
end 
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### exists
```ruby
# If we expect the resource to always exist
describe azure_storage_account(resource_group: 'rg', name: 'mysa') do
  it { should exist }
end

# If we expect the resource to never exist
describe azure_storage_account(resource_group: 'rg', name: 'mysa') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
