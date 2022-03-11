+++
title = "azure_power_bi_app_dashboards Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_power_bi_app_dashboards"
identifier = "inspec/resources/azure/azure_power_bi_app_dashboards Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_power_bi_app_dashboards` InSpec audit resource to test the properties related to all Azure Power BI App Dashboards.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_power_bi_app_dashboards` resource block returns all Azure Power BI Apps.

```ruby
describe azure_power_bi_app_dashboards(app_id: 'APP_ID') do
  #...
end
```

## Parameters

`app_id` _(required)_
: The app ID.

## Properties

`ids`
: List of all App IDs.

: **Field**: `id`

`displayNames`
: List of all the dashboard display name.

: **Field**: `displayName`

`embedUrls`
: List of all the dashboard embed url.

: **Field**: `embedUrl`

`isReadOnlies`
: List of all the boolean ReadOnly dashboard flags.

: **Field**: `isReadOnly`


{{% inspec_filter_table %}}
Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/apps/get-dashboards) for other properties available.

## Examples

**Loop through Power BI App Dashboards by their IDs.**

```ruby
azure_power_bi_app_dashboards(app_id: 'APP_ID').ids.each do |id|
  describe azure_power_bi_app_dashboard(app_id: 'APP_ID', dashboard_id: id) do
    it { should exist }
  end
end
```

**Test to filter out Power BI App Dashboards that are read only.**

```ruby
describe azure_power_bi_app_dashboards(app_id: 'APP_ID').where(isReadOnly: true) do
  it { should exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# Should not exist if no Power BI Apps are present

describe azure_power_bi_app_dashboards(app_id: 'APP_ID') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Power BI Apps

describe azure_power_bi_app_dashboards(app_id: 'APP_ID') do
  it { should exist }
end
```

## Azure Permissions

Currently this API does not support Service Principal Authentication. Hence one should use the AD account access tokens to access this resource.
Your AD account must be set up with a `Dashboard.Read.All` role on the Azure Power BI Workspace you wish to test.
