---
title: About the azure_power_bi_dataflow_storage_accounts Resource
platform: azure
---

# azure_power_bi_dataflow_storage_accounts

Use the `azure_power_bi_dataflow_storage_accounts` InSpec audit resource to test the properties related to all Azure Power BI Dataflow Storage Accounts.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax
`dataset_id` is a required parameter and `group_id` is an optional parameter.

An `azure_power_bi_dataflow_storage_accounts` resource block returns all Azure Power BI Dataflow Storage Accounts.

```ruby
describe azure_power_bi_dataflow_storage_accounts do
  #...
end
```

## Parameters

## Properties

|Property         | Description                                                            | Filter Criteria<superscript>*</superscript> |
|-----------------|------------------------------------------------------------------------|------------------|
| ids             | List of all Power BI dataflow storage account IDs.                     | `id`             |
| names           | List of all the dataflow storage account names.                        | `name`           |
| isEnableds      | List of the flags that indicates if workspaces can be assigned to the storage accounts.| `isEnabled` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/dataflow-storage-accounts/get-dataflow-storage-accounts) for other properties available.

## Examples

### Test that Power BI Dataflow Storage Accounts is enabled 

```ruby
describe azure_power_bi_dataflow_storage_accounts.where(isEnabled: true) do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Power BI Dataflow Storage Accounts are present
describe azure_power_bi_dataflow_storage_accounts do
  it { should_not exist }
end
# Should exist if the filter returns at least one Power BI Dataflow Storage Accounts
describe azure_power_bi_dataflow_storage_accounts do
  it { should exist }
end
```

## Azure Permissions
Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `StorageAccount.Read.All` role on the Azure Power BI Dataflow Storage Account you wish to test.