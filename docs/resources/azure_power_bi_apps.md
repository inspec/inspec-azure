---
title: About the azure_power_bi_apps Resource
platform: azure
---

# azure_power_bi_apps

Use the `azure_power_bi_apps` InSpec audit resource to test the properties related to all Azure Power BI apps.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_power_bi_apps` resource block returns all Azure Power BI apps.

```ruby
describe azure_power_bi_apps do
  #...
end
```

## Parameters

This resource does not require any parameters.

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | List of all app IDs.                                                   | `id`             |
| names                          | List of all the app names.                                             | `name`           |
| descriptions                   | List of all the app Descriptions.                                      | `description`    |
| lastUpdates                    | List of all Last updated times of the apps.                            | `lastUpdate`     |


<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/apps/get-apps) for other properties available.

## Examples

### Loop through Power BI apps by their IDs

```ruby
azure_power_bi_apps.ids.each do |id|
  describe azure_power_bi_app(app_id: id) do
    it { should exist }
  end
end
```

### Test that a Power BI app named "Finance" exists

```ruby
describe azure_power_bi_apps.where(name: 'Finance') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Power BI apps are present
describe azure_power_bi_apps do
  it { should_not exist }
end
# Should exist if the filter returns at least one Power BI apps
describe azure_power_bi_apps do
  it { should exist }
end
```

## Azure Permissions

This API does not support Service Principal Authentication. Use your Active Directory account access tokens to access this resource.
Your Active Directory account must be set up with an `App.Read.All` role on the Azure Power BI workspace you wish to test.
