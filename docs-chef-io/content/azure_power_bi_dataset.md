+++
title = "azure_power_bi_dataset resource"

draft = false


[menu.azure]
title = "azure_power_bi_dataset"
identifier = "inspec/resources/azure/azure_power_bi_dataset resource"
parent = "inspec/resources/azure"
+++

Use the `azure_power_bi_dataset` InSpec audit resource to test the properties related to an Azure Power BI dataset.

## Azure REST API version, endpoint, and HTTP client parameters

{{< readfile file="content/reusable/md/inspec_azure_common_parameters.md" >}}

## Syntax

```ruby
describe azure_power_bi_dataset(name: 'DATASET_ID') do
  it  { should exist }
end
```

```ruby
describe azure_power_bi_dataset(group_id: 'GROUP_ID', name: 'DATASET_ID')  do
  it  { should exist }
end
```

## Parameters

`name` _(required)_
: The dataset ID.

`group_id` _(optional)_
: The workspace ID.

## Properties

`name`
: The dataset name.

`addRowsAPIEnabled`
: Whether the dataset allows adding new rows.

`configuredBy`
: The dataset owner.

`isRefreshable`
: Can this dataset be refreshed.

`isEffectiveIdentityRequired`
: Whether the dataset requires an effective identity. This indicates that you must send an effective identity using the GenerateToken API.

`isEffectiveIdentityRolesRequired`
: Whether RLS is defined inside the PBIX file. This indicates that you must specify a role.

`isOnPremGatewayRequired`
: dataset requires an On-premises Data Gateway.

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource#properties).

Also, see the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/datasets/get-dataset) for other available properties.

## Examples

Test that the Power BI dataset requires an on-prem gateway:

```ruby
describe azure_power_bi_dataset(name: 'DATASET_ID')  do
  it { should exist }
  its('IsOnPremGatewayRequired') { should eq true }
end
```

## Matchers

{{< readfile file="content/reusable/md/inspec_matchers_link.md" >}}

### exists

```ruby
# If the Power BI dataset is found, it will exist.

describe azure_power_bi_dataset(name: 'DATASET_ID')  do
  it { should exist }
end
```

### not_exists

```ruby
# if the Power BI dataset is not found, it will not exist.

describe azure_power_bi_dataset(name: 'DATASET_ID')  do
  it { should_not exist }
end
```

## Azure permissions

Your [service principal](https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-service-principal-portal) must have the `Dataset.Read.All` role on the Azure Power BI dataset you wish to test.
