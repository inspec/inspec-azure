+++
title = "azure_power_bi_datasets resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.azure]
title = "azure_power_bi_datasets"
identifier = "inspec/resources/azure/azure_power_bi_datasets resource"
parent = "inspec/resources/azure"
+++

Use the `azure_power_bi_datasets` InSpec audit resource to test the properties of all Azure Power BI datasets.

## Azure REST API version, endpoint, and HTTP client parameters

{{< readfile file="content/reusable/md/inspec_azure_common_parameters.md" >}}

## Syntax

An `azure_power_bi_datasets` resource block returns all Azure Power BI datasets.

```ruby
describe azure_power_bi_datasets do
  #...
end
```

## Parameters

`group_id` _(optional)_
: The workspace ID.

## Properties

`ids`
: List of all Power BI dataset IDs.

  Field: `id`

`names`
: List of all the Power BI dataset names.

  Field: `name`

`addRowsAPIEnableds`
: List of boolean flags which describe whether the dataset allows adding new rows.

  Field: `addRowsAPIEnabled`

`isRefreshables`
: List of boolean flags that represent refreshable parameters of datasets.

  Field: `isRefreshable`

`isEffectiveIdentityRequireds`
: List of boolean flags that represent effective identity.

  Field: `isEffectiveIdentityRequired`

`isEffectiveIdentityRolesRequireds`
: List of boolean flags that describe whether `RLS` is defined inside the `PBIX` file.

  Field: `isEffectiveIdentityRolesRequired`

`isOnPremGatewayRequireds`
: List of boolean flags that describe whether the dataset requires an On-premises Data Gateway.

  Field: `isOnPremGatewayRequired`

{{< note >}}

{{< readfile file="content/reusable/md/inspec_filter_table.md" >}}

{{< /note>}}

Also, see the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/datasets/get-datasets) for other available properties.

## Examples

Test to ensure the Power BI dataset is refreshable:

```ruby
describe azure_power_bi_datasets.where(isRefreshable: true) do
  it { should exist }
end
```

## Matchers

{{< readfile file="content/reusable/md/inspec_matchers_link.md" >}}

This resource has the following special matchers.

### exists

```ruby
# Should not exist if no Power BI datasets are present.

describe azure_power_bi_datasets do
  it { should_not exist }
end
```

### not_exists

```ruby
# Should exist if the filter returns at least one Power BI dataset.

describe azure_power_bi_datasets do
  it { should exist }
end
```

## Azure permissions

Your [service principal](https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-service-principal-portal) must have the `Dataset.Read.All` role on the Azure Power BI dataset you wish to test.
