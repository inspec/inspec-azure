+++
title = "azure_power_bi_dashboard resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.azure]
title = "azure_power_bi_dashboard"
identifier = "inspec/resources/azure/azure_power_bi_dashboard resource"
parent = "inspec/resources/azure"
+++

Use the `azure_power_bi_dashboard` InSpec audit resource to test the properties related to Azure Power BI Dashboard.

## Azure REST API version, endpoint, and HTTP client parameters

{{< readfile file="content/reusable/md/inspec_azure_common_parameters.md" >}}

## Syntax

`dashboard_id` is a required parameter, and `group_id` is an optional parameter.

```ruby
describe azure_power_bi_dashboard(group_id: 'GROUP_ID', dashboard_id: 'dashboard_ID') do
  it  { should exist }
end
```

## Parameters

`dashboard_id` _(required)_

: The dashboard ID.

`group_id` _(optional)_

: The workspace ID.

## Properties

`id`
: Power BI dashboard ID.

`displayName`
: The dashboard display name.

`embedUrl`
: The dashboard embed URL.

`isReadOnly`
: Is ReadOnly dashboard.

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md#properties" >}}).

Also, see the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/dashboards/get-dashboard) for other available properties.

## Examples

### Test that the Power BI Dashboard is read-only

```ruby
describe azure_power_bi_dashboard(group_id: 'GROUP_ID', dashboard_id: 'DASHBOARD_ID')  do
  its('isReadOnly') { should eq 'true' }
end
```

## Matchers

{{< readfile file="content/reusable/md/inspec_matchers_link.md" >}}

### exists

```ruby
# Should exist if the Power BI dashboard is present in the group.

describe azure_power_bi_dashboard(group_id: 'GROUP_ID', dashboard_id: 'dashboard_ID')  do
  it { should exist }
end
```

### not_exists

```ruby
# Should not exist if the Power BI dashboard is not present in the group.

describe azure_power_bi_dashboard(group_id: 'GROUP_ID', dashboard_id: 'dashboard_ID')  do
  it { should_not exist }
end
```

## Azure permissions

Your [service principal](https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-service-principal-portal) must have the `Dashboard.Read.All` role on the Azure Power BI Workspace you wish to test.
