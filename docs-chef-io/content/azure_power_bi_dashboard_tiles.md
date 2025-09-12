+++
title = "azure_power_bi_dashboard_tiles resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.azure]
title = "azure_power_bi_dashboard_tiles"
identifier = "inspec/resources/azure/azure_power_bi_dashboard_tiles resource"
parent = "inspec/resources/azure"
+++

Use the `azure_power_bi_dashboard_tiles` InSpec audit resource to test the properties related to all Azure Power BI dashboard tiles within a project.

## Azure REST API version, endpoint, and HTTP client parameters

{{< readfile file="content/reusable/md/inspec_azure_common_parameters.md" >}}

## Syntax

An `azure_power_bi_dashboard_tiles` resource block returns all Azure Power BI dashboard tiles within a dashboard and a group.

```ruby
describe azure_power_bi_dashboard_tiles(dashboard_id: 'dashboard_ID') do
  #...
end
```

```ruby
describe azure_power_bi_dashboard_tiles(group_id: 'GROUP_ID') do
  #...
end
```

## Parameters

`group_id` _(required)_
: The workspace ID.

`dashboard_id` _(optional)_
: The dashboard ID.

## Properties

`ids`
: List of all dashboard IDs.

: **Field**: `id`

`titles`
: List of all the titles.

: **Field**: `title`

`embedUrls`
: List of all dashboard embed URLs.

: **Field**: `embedUrl`

`rowSpans`
: List of all row spans.

: **Field**: `rowSpan`

`colSpans`
: List of all col spans.

: **Field**: `colSpan`

`reportIds`
: List of all report IDs.

: **Field**: `reportId`

`datasetIds`
: List of all dataset IDs.

: **Field**: `datasetId`

{{< note >}}

{{< readfile file="content/reusable/md/inspec_filter_table.md" >}}

{{< /note>}}
Also, see the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/dashboards/get-dashboards) for other available properties.

## Examples

### Loop through Power BI dashboard tiles by their IDs

```ruby
azure_power_bi_dashboard_tiles.ids.each do |id|
  describe azure_power_bi_dashboard_tile(dashboard_id: id) do
    it { should exist }
  end
end
```

### Test to ensure all Power BI dashboard tiles that are in the top left corner

```ruby
describe azure_power_bi_dashboard_tiles.where(rowSpan: true) do
  it { should exist }
end
```

## Matchers

{{< readfile file="content/reusable/md/inspec_matchers_link.md" >}}

This resource has the following special matchers.

### exists

```ruby
# Use should to test for an Azure Power BI dashboard tile that should be in the resource group.

describe azure_power_bi_dashboard_tiles do
  it { should_not exist }
end
```

### not_exists

```ruby
# Use should_not to test for an Azure Power BI dashboard tile that should not be in the resource group.

describe azure_power_bi_dashboard_tiles do
  it { should exist }
end
```

## Azure permissions

Your [service principal](https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-service-principal-portal) must have the `dashboard.Read.All` role on the Azure Power BI Workspace you wish to test.
