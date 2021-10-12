---
title: About the azure_power_bi_app_dashboard_tile Resource
platform: azure
---

# azure_power_bi_app_dashboard_tile

Use the `azure_power_bi_app_dashboard_tile` InSpec audit resource to test the properties related to Azure Power BI App Dashboard Tile.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client are used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`app_id`, `dashboard_id` and `tile_id` is a required parameter.

```ruby
describe azure_power_bi_app_dashboard_tile(app_id: 'APP_ID', dashboard_id: 'DASHBOARD_ID', tile_id: 'TILE_ID') do
  it  { should exist }
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| app_id         | The app ID.                                                                      |
| dashboard_id   | The App Dashboard ID.                                                            |
| tile_id        | The App Dashboard Tile ID.

The parameter set should be provided for a valid query:

- `app_id`, `dashboard_id` and `tile_id`

## Properties

| Property                            | Description                                                      |
|-------------------------------------|------------------------------------------------------------------|
| id                                  | The tile ID.                                                     |
| title                               | The dashboard display name.                                      |
| embedUrl                            | The tile embed url.                                              |
| rowSpan                             | number of rows a tile should span.                               |
| colSpan                             | number of columns a tile should span.                            |                   
| reportId                            | The report ID, which is available only for tiles created from a report.|
| datasetId                           | The dataset ID, which is available only for tiles created from a report or using a dataset, such as Q&A tiles. |

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/apps/get-tile) for other properties available.

## Examples

### Test that the Power BI App Dashboard tile is at the left corner.

```ruby
describe azure_power_bi_app_dashboard_tile(app_id: 'APP_ID', dashboard_id: 'DASHBOARD_ID', tile_id: 'TILE_ID')  do
  its('rowSpan') { should eq 0 }
  its('colSpan') { should eq 0 }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If the Azure Power BI App Dashboard Tile is found, it will exist
describe azure_power_bi_app_dashboard_tile(app_id: 'APP_ID', dashboard_id: 'DASHBOARD_ID', tile_id: 'TILE_ID')  do
  it { should exist }
end
# if the Azure Power BI App Dashboard Tile is not found, it will not exist
describe azure_power_bi_app_dashboard_tile(app_id: 'APP_ID', dashboard_id: 'DASHBOARD_ID', tile_id: 'TILE_ID')  do
  it { should_not exist }
end
```

## Azure Permissions

Currently this API does not support Service Principal Authentication. Hence one should use the AD account access tokens to access this resource.
Your AD account must be set up with a `Dashboard.Read.All` role on the Azure Power BI Workspace you wish to test.