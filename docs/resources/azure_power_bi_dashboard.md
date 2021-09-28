---
title: About the azure_power_bi_dashboard Resource
platform: azure
---

# azure_power_bi_dashboard

Use the `azure_power_bi_dashboard` InSpec audit resource to test the properties related to Azure Power BI Dashboard.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client are used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`dashboard_id` is a required parameter and `group_id` is an optional parameter.

```ruby
describe azure_power_bi_dashboard(group_id: 'GROUP_ID', dashboard_id: 'DASHBOARD_ID') do
  it  { should exist }
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| dashboard_id   | The dashboard ID.                                                                |
| group_id       | The workspace ID.                                                                |

The parameter set should be provided for a valid query:

- `dashboard_id`
- `dashboard_id` and `group_id`

## Properties

| Property                            | Description                                                      |
|-------------------------------------|------------------------------------------------------------------|
| id                                  | Power BI Dashboard ID.                                           |
| displayName                         | The dashboard display name.                                      |
| embedUrl                            | The dashboard embed url.                                         |
| isReadOnly                          | Is ReadOnly dashboard.                                           |

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/dashboards/get-dashboard) for other properties available.

## Examples

### Test that the Power BI Dashboard is read only

```ruby
describe azure_power_bi_dashboard(group_id: 'GROUP_ID', dashboard_id: 'DASHBOARD_ID')  do
  its('isReadOnly') { should eq 'true' }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If the Azure Power BI Dashboard is found, it will exist
describe azure_power_bi_dashboard(group_id: 'GROUP_ID', dashboard_id: 'DASHBOARD_ID')  do
  it { should exist }
end
# if the Azure Power BI Dashboard is not found, it will not exist
describe azure_power_bi_dashboard(group_id: 'GROUP_ID', dashboard_id: 'DASHBOARD_ID')  do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `Dashboard.Read.All` role on the Azure Power BI Workspace you wish to test.
