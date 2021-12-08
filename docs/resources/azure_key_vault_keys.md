---
title: About the azure_key_vault_keys Resource
platform: azure
---

# azure_key_vault_keys

Use the `azure_key_vault_keys` InSpec audit resource to test properties and configuration of multiple of Azure keys within vaults.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_key_vault_keys` resource block returns all keys within a vault.

```ruby
describe azure_key_vault_keys(vault_name: 'example_vault') do
  #...
end
```

## Parameters

`vault_name`

The name of the vault.

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| attributes    | A list of the key management attributes in [this](https://docs.microsoft.com/en-us/rest/api/keyvault/getkey/getkey#keyattributes) format.  | `attributes`            |
| kids          | A list of key ids.                                                                   | `kid`           |
| managed       | A list of boolean values indicating if the keys are managed by key vault or not.     | `managed`       |
| tags          | A list of `tag:value` pairs defined on the resources being interrogated.             | `tags`          |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test that a Vault has the Named Key
```ruby
describe azure_key_vault_keys(vault_name: 'example_vault').where { kid.include?('my_key')} do
  it { should exist }
  its('count') { should be 1 }
end
```
### Loop through Keys by the Key ID
```ruby
azure_key_vault_keys(vault_name: 'example_vault').kids.each do |kid|
  describe azure_key_vault_key(key_id: kid) do
    it { should exist }
  end 
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.
```ruby
# If we expect to have at least one key in a vault
describe azure_key_vault_keys(vault_name: 'example_vault') do
  it { should exist }
end

# If we expect not have any keys in a vault
describe azure_key_vault_keys(vault_name: 'example_vault') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
