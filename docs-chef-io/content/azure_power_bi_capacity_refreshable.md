+++
title = "azure_power_bi_capacity_refreshable resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.azure]
title = "azure_power_bi_capacity_refreshable"
identifier = "inspec/resources/azure/azure_power_bi_capacity_refreshable resource"
parent = "inspec/resources/azure"
+++

Use the `azure_power_bi_capacity_refreshable` InSpec audit resource to test the properties of an Azure Power BI Capacity refreshable.

## Azure REST API version, endpoint, and HTTP client parameters

{{< readfile file="content/reusable/md/inspec_azure_common_parameters.md" >}}

## Syntax

```ruby
describe azure_power_bi_capacity_refreshable(capacity_id: 'CAPACITY_ID', name: 'REFRESHABLE_ID') do
  it { should exist }
end
```

```ruby
describe azure_power_bi_capacity_refreshable(capacity_id: 'CAPACITY_ID', name: 'REFRESHABLE_ID')  do
  it { should exist }
end
```

## Parameters

`name` _(required)_

: The refreshable ID.

`capacity_id` _(required)_

: The capacity ID.

## Properties

`id`
: The object ID of the refreshable.

`kind`
: The refreshable kind.

`name`
: Display refreshable name.

`startTime`
: The start time of the window for which summary data exists.

`endTime`
: The end time of the window for which summary data exists.

`refreshCount`
: The number of refreshes within the summary time window.

`refreshFailures`
: The number of refresh failures within the summary time window.

`refreshesPerDay`
: The number of refreshes (schedule+onDemand) per day within the summary time window with at most 60.

`refreshSchedule.days`
: Days to execute the refresh.

`refreshSchedule.enabled`
: Is the refresh enabled.

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`]({{< relref "azure_generic_resource.md#properties" >}}).

Also, see the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/capacities/get-refreshable-for-capacity) for other available properties.

## Examples

### Test that the Power BI Capacity refreshable schedule is enabled

```ruby
describe azure_power_bi_capacity_refreshable(capacity_id: 'CAPACITY_ID', name: 'REFRESHABLE_ID')  do
  its('refreshSchedules.enabled') { should be_truthy }
end
```

## Matchers

{{< readfile file="content/reusable/md/inspec_matchers_link.md" >}}

### exists

```ruby
# If the Power BI Capacity refreshable is found, it will exist.

describe azure_power_bi_capacity_refreshable(capacity_id: 'CAPACITY_ID', name: 'REFRESHABLE_ID')  do
  it { should exist }
end
```

### not_exists

```ruby
# if the Power BI Capacity refreshable is not found, it will not exist.
describe azure_power_bi_capacity_refreshable(capacity_id: 'CAPACITY_ID', name: 'REFRESHABLE_ID')  do
  it { should_not exist }
end
```

## Azure permissions

Your [service principal](https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-service-principal-portal) must have the `Capacity.Read.All` role on the Azure Power BI Capacity you wish to test.
