---
title: About the azure_power_bi_dataset Resource
platform: azure
---

# azure_power_bi_dataset

Use the `azure_power_bi_dataset` InSpec audit resource to test the properties related to Azure Power BI Dataset.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client are used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

- `name` is a required parameter.
- `group_id` is an optional parameter.

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

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | The Dataset ID.                                                                  |
| group_id       | The workspace ID.(optional)                                                      |

The parameter set should be provided for a valid query:

- `name`
- `name` and `group_id`

## Properties

| Property                   | Description                                                      |
|----------------------------|------------------------------------------------------------------|
| name                       | The dataset name.                                                |
| addRowsAPIEnabled          | Whether the dataset allows adding new rows.                      |
| configuredBy               | The dataset owner.                                               |           
| isRefreshable              | Can this dataset be refreshed.                                   |
| isEffectiveIdentityRequired| Whether the dataset requires an effective identity. This indicates that you must send an effective identity using the GenerateToken API.|
| isEffectiveIdentityRolesRequired | Whether RLS is defined inside the PBIX file. This indicates that you must specify a role.|
| isOnPremGatewayRequired    | Dataset requires an On-premises Data Gateway.                    |


For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/datasets/get-dataset) for other properties available.

## Examples

### Test that the Power BI Dataset requires an on-prem Gateway 

```ruby
describe azure_power_bi_dataset(name: 'DATASET_ID')  do
  it { should exist }
  its('IsOnPremGatewayRequired') { should eq true }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If the Power BI Dataset is found, it will exist
describe azure_power_bi_dataset(name: 'DATASET_ID')  do
  it { should exist }
end
# if the Power BI Dataset is not found, it will not exist
describe azure_power_bi_dataset(name: 'DATASET_ID')  do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `Dataset.Read.All` role on the Azure Power BI Dataset you wish to test.