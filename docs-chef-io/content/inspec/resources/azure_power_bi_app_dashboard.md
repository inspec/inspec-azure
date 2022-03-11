+++
title = "azure_power_bi_app_dashboard Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_power_bi_app_dashboard"
identifier = "inspec/resources/azure/azure_power_bi_app_dashboard Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_power_bi_app_dashboard` InSpec audit resource to test the properties related to Azure Power BI Apps.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

`app_id` is a required parameter.

```ruby
describe azure_power_bi_app_dashboard(app_id: 'APP_ID', dashboard_id: 'DASHBOARD_ID') do
  it  { should exist }
end
```

## Parameters

`app_id`
: The app ID.

`dashboard_id`
: The App Dashboard ID.

The parameter set should be provided for a valid query:

- `app_id` & `dashboard_id`

## Properties

`id`
: The app ID.

`displayName`
: The dashboard display name.

`embedUrl`
: The dashboard embed url.

`isReadOnly`
: Is ReadOnly dashboard.

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md#properties" >}}).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/apps/get-dashboard) for other properties available.

## Examples

**Test that the Power BI App Dashboard is read only.**

```ruby
describe azure_power_bi_app_dashboard(app_id: 'APP_ID', dashboard_id: 'DASHBOARD_ID')  do
  its('isReadOnly') { should eq true }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# If the Azure Power BI App Dashboard is found, it will exist
describe azure_power_bi_app_dashboard(app_id: 'APP_ID', dashboard_id: 'DASHBOARD_ID')  do
  it { should exist }
end
# if the Azure Power BI App Dashboard is not found, it will not exist
describe azure_power_bi_app_dashboard(app_id: 'APP_ID', dashboard_id: 'DASHBOARD_ID')  do
  it { should_not exist }
end
```

## Azure Permissions

Currently this API does not support Service Principal Authentication. Hence one should use the AD account access tokens to access this resource.
Your AD account must be set up with a `Dashboard.Read.All` role on the Azure Power BI Workspace you wish to test.