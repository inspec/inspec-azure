---
title: About the azure_power_bi_dataset_datasources Resource
platform: azure
---

# azure_power_bi_dataset_datasources

Use the `azure_power_bi_dataset_datasources` Chef InSpec audit resource to test the properties of all Azure Power BI dataset data sources.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client are used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [Chef InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_power_bi_dataset_datasources` resource block returns all Azure Power BI dataset data sources.

```ruby
describe azure_power_bi_dataset_datasources(dataset_id: 'DATASET_ID') do
  #...
end
```

## Parameters

`dataset_id` _(required)_

The dataset ID.

`group_id` _(optional)_

The workspace ID.

## Properties

|Property                   | Description                                                            | Filter Criteria<superscript>*</superscript> |
|---------------------------|------------------------------------------------------------------------|------------------|
| datasourceIds             | List of all Power BI data source IDs.                                  | `datasourceId`   |
| gatewayIds                | List of all the bound gateway IDs.                                     | `gatewayId`      |
| datasourceTypes           | List of the data source types.                                         | `datasourceType` |
| connectionDetails         | List of the data source connection details.                            | `connectionDetails` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/datasets/get-datasources) for other properties available.

## Examples

### Verify that a Power BI dataset data source for a server exists

```ruby
describe azure_power_bi_dataset_datasources(dataset_id: 'DATASET_ID').where{ connectionDetails[:server] == 'CONNECTION_SERVER' } do
  it { should exist }
end
```

## Matchers

This Chef InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

**Verify that a Power BI dataset data source is not present.**

```ruby
describe azure_power_bi_dataset_datasources(dataset_id: 'DATASET_ID') do
  it { should_not exist }
end
```

**Verify that at least one Power BI dataset data source exists.**

```
describe azure_power_bi_dataset_datasources(dataset_id: 'DATASET_ID') do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `Dataset.Read.All` role on the Azure Power BI data set you wish to test.
