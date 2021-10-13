---
title: About the azure_power_bi_app_reports Resource
platform: azure
---

# azure_power_bi_app_reports

Use the `azure_power_bi_app_reports` InSpec audit resource to test the properties related to all Azure Power BI App Reports.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_power_bi_app_reports` resource block returns all Azure Power BI App Reports.

```ruby
describe azure_power_bi_app_reports(app_id: 'APP_ID') do
  #...
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| app_id         | The app ID.                                                                      |

The parameter set should be provided for a valid query:

- `app_id`

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | List of all App Report IDs.                                            | `id`             |
| embedUrls                      | List of all the Report embed urls.                                     | `embedUrl`       |
| appIds                         | List of all the App IDs.                                               | `appId`        |
| datasetIds                     | List of all the Dataset IDs.                                           | `datasetId`        |
| names                          | List of all the report names.                                          | `name`       |
| webUrls                        | List of all the report web URLs.                                       | `webUrl`      |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/apps/get-reports) for other properties available.

## Examples

### Loop through Power BI App Reports by their IDs

```ruby
azure_power_bi_app_reports(app_id: 'APP_ID').ids.each do |id|
  describe azure_power_bi_app_report(app_id: 'APP_ID', report_id: id) do
    it { should exist }
  end
end
```

### Test to filter out Power BI App Reports that have webUrl

```ruby
describe azure_power_bi_app_reports(app_id: 'APP_ID').where(name: 'SalesMarketing') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Power BI App Reports are present
describe azure_power_bi_app_reports(app_id: 'APP_ID') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Power BI App Reports
describe azure_power_bi_app_reports(app_id: 'APP_ID') do
  it { should exist }
end
```

## Azure Permissions

Currently this API does not support Service Principal Authentication. Hence one should use the AD account access tokens to access this resource.
Your AD account must be set up with a `Report.Read.All` role on the Azure Power BI Workspace you wish to test.