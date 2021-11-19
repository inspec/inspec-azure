---
title: About the azure_power_bi_app_report Resource
platform: azure
---

# azure_power_bi_app_report

Use the `azure_power_bi_app_report` InSpec audit resource to test the properties related to Azure Power BI App report.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client are used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`app_id` and `report_id` is a required parameter.

```ruby
describe azure_power_bi_app_report(app_id: 'APP_ID', report_id: 'REPORT_ID') do
  it  { should exist }
end
```

## Parameters

`app_id` _(required)_

The App ID.

`report_id` _(required)_

The App report ID.

## Properties

| Property                            | Description                                                      |
|-------------------------------------|------------------------------------------------------------------|
| id                                  | The report ID.                                                   |
| appId                               | The App ID.                                                      |
| embedUrl                            | The report embed url.                                            |
| datasetId                           | The dataset ID.                                                  |
| name                                | The report name.                                                 |
| webUrl                              | The report web url.                                              |

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/apps/get-report) for other properties available.

## Examples

### Test that the Power BI App report is at the left corner.

```ruby
describe azure_power_bi_app_report(app_id: 'APP_ID', report_id: 'REPORT_ID')  do
  its('rowSpan') { should eq 0 }
  its('colSpan') { should eq 0 }
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
