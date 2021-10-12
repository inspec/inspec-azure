---
title: About the azure_power_bi_app_dashboard_tiles Resource
platform: azure
---

# azure_power_bi_app_dashboard_tiles

Use the `azure_power_bi_app_dashboard_tiles` InSpec audit resource to test the properties related to all Azure Power BI App Dashboard Tiles.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_power_bi_app_dashboard_tiles` resource block returns all Azure Power BI App Dashboard Tiles.

```ruby
describe azure_power_bi_app_dashboard_tiles(app_id: 'APP_ID', dashboard_id: 'DASHBOARD_ID') do
  #...
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| app_id         | The app ID.                                                                      |
| dashboard_id   | The dashboard ID.                                                                |

The parameter set should be provided for a valid query:

- `app_id` and `dashboard_id`

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | List of all App Dashboard Tile IDs.                                    | `id`             |
| titles                         | List of all the dashboard title.                                       | `title`          |
| embedUrls                      | List of all the dashboard embed urls.                                  | `embedUrl`       |
| rowSpans                       | List of all the row span values.                                       | `rowSpan`        |
| colSpans                       | List of all the col span values.                                       | `colSpan`        |
| reportIds                      | List of all the report IDs.                                            | `reportId`       |
| datasetIds                     | List of all the dataset IDs.                                           | `datasetId`      |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/apps/get-tiles) for other properties available.

## Examples

### Loop through Power BI App Dashboard Tiles by their IDs

```ruby
azure_power_bi_app_dashboard_tiles(app_id: 'APP_ID', dashboard_id: 'DASHBOARD_ID').ids.each do |id|
  describe azure_power_bi_app_dashboard_tile(app_id: 'APP_ID', dashboard_id: 'DASHBOARD_ID', tile_id: id) do
    it { should exist }
  end
end
```

### Test to filter out Power BI App Dashboard Tiles that are in left corner

```ruby
describe azure_power_bi_app_dashboard_tiles(app_id: 'APP_ID', dashboard_id: 'DASHBOARD_ID').where(rowSpan: 0, colSpan: 0) do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Power BI App Dashboard Tiles are present
describe azure_power_bi_app_dashboard_tiles(app_id: 'APP_ID') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Power BI App Dashboard Tiles
describe azure_power_bi_app_dashboard_tiles(app_id: 'APP_ID') do
  it { should exist }
end
```

## Azure Permissions

Currently this API does not support Service Principal Authentication. Hence one should use the AD account access tokens to access this resource.
Your AD account must be set up with a `Dashboard.Read.All` role on the Azure Power BI Workspace you wish to test.