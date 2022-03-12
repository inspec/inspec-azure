+++
title = "azure_power_bi_app_reports Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_power_bi_app_reports"
identifier = "inspec/resources/azure/azure_power_bi_app_reports Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_power_bi_app_reports` InSpec audit resource to test the properties related to all Azure Power BI App reports.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_power_bi_app_reports` resource block returns all Azure Power BI App reports.

```ruby
describe azure_power_bi_app_reports(app_id: 'APP_ID') do
  #...
end
```

## Parameters

`app_id` _(required)_

: The App ID.

## Properties

`ids`
: List of all App report IDs.

: **Field**: `id`

`embedUrls`
: List of all the report embed urls.

: **Field**: `embedUrl`

`appIds`
: List of all the App IDs.

: **Field**: `appId`

`datasetIds`
: List of all the Dataset IDs.

: **Field**: `datasetId`

`names`
: List of all the report names.

: **Field**: `name`

`webUrls`
: List of all the report web URLs.

: **Field**: `webUrl`

{{% inspec_filter_table %}}
Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/apps/get-reports) for other properties available.

## Examples

**Loop through Power BI App reports by their IDs.**

```ruby
azure_power_bi_app_reports(app_id: 'APP_ID').ids.each do |id|
  describe azure_power_bi_app_report(app_id: 'APP_ID', report_id: id) do
    it { should exist }
  end
end
```

**Test to filter out Power BI App reports by report name.**

```ruby
describe azure_power_bi_app_reports(app_id: 'APP_ID').where(name: 'REPORT_NAME') do
  it { should exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# Should not exist if no Power BI App reports are present

describe azure_power_bi_app_reports(app_id: 'APP_ID') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Power BI App reports

describe azure_power_bi_app_reports(app_id: 'APP_ID') do
  it { should exist }
end
```

## Azure Permissions

This API does not support service principal authentication. Instead, use an Active Directory account access token to access this resource.
Your Active Directory account must be set up with a `Report.Read.All` role on the Azure Power BI workspace that you wish to test.
