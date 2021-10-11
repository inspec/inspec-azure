---
title: About the azure_power_bi_app_dashboards Resource
platform: azure
---

# azure_power_bi_app_dashboards

Use the `azure_power_bi_app_dashboards` InSpec audit resource to test the properties related to all Azure Power BI App Dashboards.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_power_bi_app_dashboards` resource block returns all Azure Power BI Apps.

```ruby
describe azure_power_bi_app_dashboards(app_id: 'APP_ID') do
  #...
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| app_id         | The app ID.                                                                |

The parameter set should be provided for a valid query:

- `app_id`

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | List of all App IDs.                                                   | `id`             |
| displayNames                   | List of all the dashboard display name.                                | `displayName`    |
| embedUrls                      | List of all the dashboard embed url.                                   | `embedUrl`       |
| isReadOnlies                   | List of all the boolean ReadOnly dashboard flags.                      | `isReadOnly`     |


<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/apps/get-dashboards) for other properties available.

## Examples

### Loop through Power BI App Dashboards by their IDs

```ruby
azure_power_bi_app_dashboards(app_id: 'APP_ID').ids.each do |id|
  describe azure_power_bi_app_dashboard(app_id: 'APP_ID', dashboard_id: id) do
    it { should exist }
  end
end
```

### Test to filter out Power BI App Dashboards that are read only

```ruby
describe azure_power_bi_app_dashboards(app_id: 'APP_ID').where(isReadOnly: true) do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

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
