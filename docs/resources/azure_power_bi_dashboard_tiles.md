---
title: About the azure_power_bi_dashboard_tiles Resource
platform: azure
---

# azure_power_bi_dashboard_tiles

Use the `azure_power_bi_dashboard_tiles` InSpec audit resource to test the properties related to all Azure  Power BI Dashboard Tiles within a project.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_power_bi_dashboard_tiles` resource block returns all Azure Power BI Dashboard Tiles within dashboard and a group.

```ruby
describe azure_power_bi_dashboard_tiles(dashboard_id: 'DASHBOARD_ID') do
  #...
end
```

```ruby
describe azure_power_bi_dashboard_tiles(group_id: 'GROUP_ID') do
  #...
end
```

## Parameters
| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| group_id       | The workspace ID.                                                                |
| dashboard_id   | The dashboard ID.

The parameter set should be provided for a valid query:
- `dashboard_id`
- `dashboard_id` and `group_id`

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | List of all dashboard IDs.                                             | `id`             |
| titles                         | List of all the titles.                                                | `title`          |
| embedUrls                      | List of all dashboard embed urls.                                      | `embedUrl`       |
| rowSpans                       | List of all row spans.                                                 | `rowSpan`        |
| colSpans                       | List of all col spans.                                                 | `colSpan`        |
| reportIds                      | List of all report IDs.                                                | `reportId`       |
| datasetIds                     | List of all dataset IDs.                                               | `datasetId`      |


<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/dashboards/get-dashboards) for other properties available.

## Examples

### Loop through Power BI Dashboard Tiles by their IDs

```ruby
azure_power_bi_dashboard_tiles.ids.each do |id|
  describe azure_power_bi_dashboard_tile(dashboard_id: id) do
    it { should exist }
  end
end
```

### Test to ensure all Power BI Dashboard Tiles that are in top left corner

```ruby
describe azure_power_bi_dashboard_tiles.where(rowSpan: true) do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Power BI Dashboard Tiles are present in the group
describe azure_power_bi_dashboard_tiles do
  it { should_not exist }
end
# Should exist if the filter returns at least one Power BI Dashboard tiles in the group
describe azure_power_bi_dashboard_tiles do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `Dashboard.Read.All` role on the Azure Power BI Workspace you wish to test.