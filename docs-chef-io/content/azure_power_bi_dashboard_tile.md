+++
title = "azure_power_bi_dashboard_tile resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.azure]
title = "azure_power_bi_dashboard_tile"
identifier = "inspec/resources/azure/azure_power_bi_dashboard_tile resource"
parent = "inspec/resources/azure"
+++

Use the `azure_power_bi_dashboard_tile` InSpec audit resource to test the properties related to an Azure Power BI dashboard tile.

## Azure REST API version, endpoint, and HTTP client parameters

{{< readfile file="content/reusable/md/inspec_azure_common_parameters.md" >}}

## Syntax

```ruby
describe azure_power_bi_dashboard_tile(group_id: 'GROUP_ID', dashboard_id: 'dashboard_ID', title_id: 'TITLE_ID') do
  it  { should exist }
end
```

## Parameters

`dashboard_id` _(required)_

: The dashboard ID.

`tile_id` _(required)_

: The tile ID.

`group_id` _(optional)_

: The workspace ID.

## Properties

`id`
: Power BI dashboard tile ID.

`title`
: The dashboard display name.

`embedUrl`
: The tile embed URL.

`rowSpan`
: The number of rows a tile should span.

`colSpan`
: The number of columns a tile should span.

`reportId`
: The report ID available only for tiles created from a report.

`datasetId`
: The dataset ID available only for tiles created from a report or using a dataset, such as Q&A tiles.

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource#properties).

Also, see the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/dashboards/get-tile) for other available properties.

## Examples

### Test that the Power BI dashboard tile is on the left corner

```ruby
describe azure_power_bi_dashboard_tile(group_id: 'GROUP_ID', dashboard_id: 'dashboard_ID', title_id: 'TITLE_ID')  do
  its('rowSpan') { should eq 0 }
end
```

## Matchers

{{< readfile file="content/reusable/md/inspec_matchers_link.md" >}}

### exists

```ruby
# Use should to test for an Azure Power BI dashboard tile that should be in the resource group.

describe azure_power_bi_dashboard_tile(group_id: 'GROUP_ID', dashboard_id: 'dashboard_ID', title_id: 'TITLE_ID')  do
  it { should exist }
end
```

### not_exists

```ruby
# Use should_not to test for an Azure Power BI dashboard tile that should not be in the resource group.

describe azure_power_bi_dashboard_tile(group_id: 'GROUP_ID', dashboard_id: 'dashboard_ID', title_id: 'TITLE_ID')  do
  it { should_not exist }
end
```

## Azure permissions

Your [service principal](https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-service-principal-portal) must have the `dashboard.Read.All` role on the Azure Power BI Workspace you wish to test.
