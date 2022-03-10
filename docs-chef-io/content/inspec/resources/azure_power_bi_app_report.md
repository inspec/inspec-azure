+++
title = "azure_power_bi_app_report Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_power_bi_app_report"
identifier = "inspec/resources/azure/azure_power_bi_app_report Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_power_bi_app_report` InSpec audit resource to test the properties related to Azure Power BI App report.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

`app_id` and `report_id` is a required parameter.

```ruby
describe azure_power_bi_app_report(app_id: 'APP_ID', report_id: 'REPORT_ID') do
  it  { should exist }
end
```

## Parameters

`app_id` _(required)_

: The App ID.

`report_id` _(required)_

: The App report ID.

## Properties

`id`
: The report ID.

`appId`
: The App ID.

`embedUrl`
: The report embed url.

`datasetId`
: The dataset ID.

`name`
: The report name.

`webUrl`
: The report web url.

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md#properties" >}}).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/apps/get-report) for other properties available.

## Examples

**Test that the Power BI App report is paginated and embed URL is present.**

```ruby
describe azure_power_bi_app_report(app_id: 'APP_ID', report_id: 'REPORT_ID')  do
  its('reportType') { should eq 'PaginatedReport' }
  its('embedUrl') { should_not be_empty }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

Use `should` to test that the entity exists.

```ruby
describe azure_power_bi_app_report(app_id: 'APP_ID', report_id: 'REPORT_ID')  do
  it { should exist }
end
```

Use `should_not` to test that the entity does not exist.

```ruby
describe azure_power_bi_app_report(app_id: 'APP_ID', report_id: 'REPORT_ID')  do
  it { should_not exist }
end
```

## Azure Permissions

This API does not support service principal authentication. Instead, use an Active Directory account access token to access this resource.
Your Active Directory account must be set up with a `Report.Read.All` role on the Azure Power BI workspace that you wish to test.
