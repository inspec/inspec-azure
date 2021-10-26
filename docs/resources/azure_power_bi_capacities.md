---
title: About the azure_power_bi_app_capacities Resource
platform: azure
---

# azure_power_bi_app_capacities

Use the `azure_power_bi_app_capacities` InSpec audit resource to test the properties related to all Azure Power BI Capacities.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_power_bi_app_capacities` resource block returns all Azure Power BI Capacities.

```ruby
describe azure_power_bi_app_capacities do
  #...
end
```

## Parameters

## Properties

|Property                   | Description                                                            | Filter Criteria<superscript>*</superscript> |
|---------------------------|------------------------------------------------------------------------|------------------|
| ids                       | List of all Power Bi Capacity IDs.                                     | `id`             |
| displayNames              | List of all the Power Bi Capacity names.                               | `displayName`    |
| admins                    | An array of capacity admins.                                           | `admin`          |
| skus                      | List of all capacity SKUs.                                             | `sku`            |
| states                    | List of the capacity states.                                           | `state`          |
| regions                   | List of the Azure regions where the capacity is provisioned.           | `region`         |
| capacityUserAccessRights  | List of Access rights user has on the capacity.                        | `capacityUserAccessRight`|

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/capacities/get-capacities) for other properties available.

## Examples

### Test to ensure Power BI Capacities are active

```ruby
describe azure_power_bi_app_capacities.where(state: 'Active') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Power BI Capacities are present
describe azure_power_bi_app_capacities do
  it { should_not exist }
end
# Should exist if the filter returns at least one Power BI Capacities
describe azure_power_bi_app_capacities do
  it { should exist }
end
```

## Azure Permissions

Currently this API does not support Service Principal Authentication. Hence one should use the AD account access tokens to access this resource.
Your AD account must be set up with a `Capacity.Read.All` role on the Azure Power BI Workspace you wish to test.