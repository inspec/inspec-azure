---
title: About the azure_key_vault Resource
platform: azure
---

# azure_key_vault

Use the `azure_key_vault` InSpec audit resource to test properties related to a key vault.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used .
For more information, refer to the resource pack [README](../../README.md). 

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group` and `name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_key_vault(resource_group: 'inspec-resource-group', name: 'vault-101') do
  it            { should exist }
  its('name')   { should cmp 'vault-101' }    
end
```
```ruby
describe azure_key_vault(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.KeyVault/vaults/{vaultName}') do
  it            { should exist }
end
```
## Parameters

| Name                            | Description                                                                      |
|---------------------------------|----------------------------------------------------------------------------------|
| resource_group                  | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| name                            | Name of the Azure resource to test. `MyVault`                                    |
| vault_name                      | Name of the Azure resource to test (for backward compatibility). `MyVault`       |
| resource_id                     | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.KeyVault/vaults/{vaultName}` |
| diagnostic_settings_api_version | The endpoint api version for the `diagnostic_settings` property. `2017-05-01-preview` will be used for backward compatibility unless provided. |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`
- `resource_group` and `vault_name`

## Properties

| Property                              | Description |
|---------------------------------------|-------------|
| diagnostic_settings                   | The active diagnostic settings list for the key vault. |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/keyvault/vaults/get#vault) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test Key Vault's SKU Family
```ruby
describe azure_key_vault(resource_group: 'MyResourceGroup', name: 'MyVaultName') do
  its('properties.sku.family') { should eq 'A' }
end
```
### Test If Key Vault is Enabled for Disk Encryption
```ruby
describe azure_key_vault(resource_group: 'MyResourceGroup', name: 'MyVaultName') do
  its('properties.enabledForDiskEncryption') { should be_true }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists
```ruby
# If a key vault is found it will exist
describe azure_key_vault(resource_group: 'MyResourceGroup', name: 'MyVaultName') do
  it { should exist }
end

# Key vaults that aren't found will not exist
describe azure_key_vault(resource_group: 'MyResourceGroup', name: 'DoesNotExist') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
