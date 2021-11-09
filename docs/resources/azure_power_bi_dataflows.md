---
title: About the azure_power_bi_dataflows Resource
platform: azure
---

# azure_power_bi_dataflows

Use the `azure_power_bi_dataflows` InSpec audit resource to test the properties related to all Azure Power BI Dataflows.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_power_bi_dataflows` resource block returns all Azure Power BI Dataflows.

```ruby
describe azure_power_bi_dataflows(group_id: 'GROUP_ID') do
  #...
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| group_id       | The Workspace ID.                                                                |


## Properties

|Property                   | Description                                                            | Filter Criteria<superscript>*</superscript> |
|---------------------------|------------------------------------------------------------------------|------------------|
| objectIds                 | List of all Power BI dataflow IDs.                                     | `objectId`       |
| names                     | List of all the Power BI dataflow names.                               | `name`           |
| descriptions              | List of all the Power BI dataflow descriptions.                        | `description`    |
| modelUrls                 | List of all URLs to the dataflow definition file                       | `modelUrl`       |                                                          | `modelUrl` |


<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/dataflows/get-dataflows) for other properties available.

## Examples

### Test to ensure Power BI Dataflow for Finance exists

```ruby
describe azure_power_bi_dataflows(group_id: 'GROUP_ID').where(name: 'FinanceWorks') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Power BI Dataflows are present
describe azure_power_bi_dataflows(group_id: 'GROUP_ID') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Power BI Dataflows
describe azure_power_bi_dataflows(group_id: 'GROUP_ID') do
  it { should exist }
end
```

## Azure Permissions
Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `Dataflow.Read.All` role on the Azure Power BI Dataflow you wish to test.