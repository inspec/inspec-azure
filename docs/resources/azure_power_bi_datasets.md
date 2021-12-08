---
title: About the azure_power_bi_datasets Resource
platform: azure
---

# azure_power_bi_datasets

Use the `azure_power_bi_datasets` InSpec audit resource to test the properties of all Azure Power BI datasets.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_power_bi_datasets` resource block returns all Azure Power BI datasets.

```ruby
describe azure_power_bi_datasets do
  #...
end
```

## Parameters

`group_id` _(optional)_

The workspace ID.

## Properties

|Property                   | Description                                                            | Filter Criteria<superscript>*</superscript> |
|---------------------------|------------------------------------------------------------------------|------------------|
| ids                       | List of all Power BI dataset IDs.                                      | `id`             |
| names                     | List of all the Power BI dataset names.                                | `name`           |
| addRowsAPIEnableds        | List of boolean flags which describes whether the dataset allows adding new rows.| `addRowsAPIEnabled`|
| isRefreshables            | List of boolean flags that represent refreshable parameter of datasets. | `isRefreshable` |
| isEffectiveIdentityRequireds | List of boolean flags that represent effective identity.             | `isEffectiveIdentityRequired` |
| isEffectiveIdentityRolesRequireds | List of boolean flags that describes whether RLS is defined inside the PBIX file. | `isEffectiveIdentityRolesRequired` |
| isOnPremGatewayRequireds | List of boolean flags that describes whether dataset requires an On-premises Data Gateway.| `isOnPremGatewayRequired` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/datasets/get-datasets) for other properties available.

## Examples

### Test to ensure Power BI dataset is refreshable

```ruby
describe azure_power_bi_datasets.where(isRefreshable: true) do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Power BI datasets are present
describe azure_power_bi_datasets do
  it { should_not exist }
end
# Should exist if the filter returns at least one Power BI datasets
describe azure_power_bi_datasets do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `Dataset.Read.All` role on the Azure Power BI dataset you wish to test.
