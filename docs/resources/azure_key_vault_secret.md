---
title: About the azure_key_vault_secret Resource
platform: azure
---

# azure_key_vault_secret

Use the `azure_key_vault_secret` InSpec audit resource to test properties and configuration of an Azure secret within a vault.

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

An `azure_key_vault_secret` resource block identifies an Azure secret by `vault_name` and `secret_name` or the `secret_id`.
You may also specify a `secret_version` - if no version is specified, the most recent version of the secret will be used.
```ruby
describe azure_key_vault_secret(vault_name: 'example_vault', secret_name: 'example_secret') do
  it { should exist }
end
```
```ruby
describe azure_key_vault_secret(vault_name: 'example_vault', secret_name: 'example_secret', secret_version: '78deebed173b48e48f55abf87ed4cf71') do
  it { should exist }
end
```
```ruby
describe azure_key_vault_secret(secret_id: 'https://example_vault.vault.azure.net/secrets/secret_name/7df9bf2c3b4347bab213ebe233f0e350') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| vault_name                     | The name of the key vault that the targeted secret resides in. `my_vault`         |
| secret_name                    | The name of the secret to interrogate. `my_secret`                                |
| name                           | Alias for the `secret_name` parameter. `my_secret`                                |
| secret_version                 | (Optional) - The version of a secret, e.g. `7df9bf2c3b4347bab213ebe233f0e350`.    |
| secret_id                      | The unique id of the secret, e.g. `https://example_vault.vault.azure.net/secrets/secret_name/7df9bf2c3b4347bab213ebe233f0e350`. |

Either one of the parameter sets can be provided for a valid query:
- `vault_name` and `secret_name`
- `vault_name` and `name`
- `secret_id`

## Properties

| Property              | Description |
|-----------------------|-------------|
| id                    | The secret id. `https://example_vault.vault.azure.net/secrets/secret_name` |
| kid                   | If this is a secret backing a KV certificate, then this field specifies the corresponding key backing the KV certificate. |
| attributes            | The secret management attributes in [this](https://docs.microsoft.com/en-us/rest/api/keyvault/getsecret/getsecret#secretattributes) format. |
| contentType           | The content type of the secret. |
| content_type          | Alias for the `contentType`. |
| managed               | `true` if the secret's lifetime is managed by key vault. If this is a secret backing a certificate, then managed will be `true`. |
| tags                  | Application specific metadata in the form of key-value pairs. |
| value                 | The secret's value. |

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/keyvault/getsecret/getsecret#secretbundle) for more details. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test the Secret Identifier
```ruby
describe azure_key_vault_secret(vault_name: 'example_vault', secret_name: 'example_secret') do
  its('id') { should cmp 'https://example_vault.vault.azure.net/secrets/example_secret' }
end
```
### Test if the Secret is Enabled
```ruby
describe azure_key_vault_secret(vault_name: 'example_vault', secret_name: 'example_secret') do
  its('attributes.enabled') { should eq true }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### exists
```ruby
# If we expect the secret to always exist
describe azure_key_vault_secret(vault_name: 'example_vault', secret_name: 'example_secret') do
  it { should exist }
end

# If we expect the secret to never exist
describe azure_key_vault_secret(vault_name: 'example_vault', secret_name: 'example_secret') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
