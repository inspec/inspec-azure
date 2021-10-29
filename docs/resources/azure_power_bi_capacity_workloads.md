---
title: About the azure_power_bi_capacity_workloads Resource
platform: azure
---

# azure_power_bi_capacity_workloads

Use the `azure_power_bi_capacity_workloads` InSpec audit resource to test the properties related to all Azure Power BI Capacity Workloads.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_power_bi_capacity_workloads` resource block returns all Azure Power BI Capacity Workloads.

```ruby
describe azure_power_bi_capacity_workloads do
  #...
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| capacity_id    | The capacity ID.                                                                      |


## Properties

|Property                   | Description                                                            | Filter Criteria<superscript>*</superscript> |
|---------------------------|------------------------------------------------------------------------|------------------|
| ids                       | List of all Power Bi Capacity Workload IDs.                         | `id`             |
| names                     | List of all the Power Bi Capacity Workload names.                   | `name`           |
| kinds                     | List of all the Power Bi Capacity Workload Kinds                    | `kind`           |
| refreshCounts             | List of the number of refreshes within the summary time windows.       | `refreshCount`   |
| refreshFailures           | List of the number of refresh failures within the summary time window. | `refreshFailures`|
| refreshesPerDays          | List of the number of refreshes.                                       | `refreshesPerDay`|
| medianDurations           | List of the median duration in seconds of a refresh.                   | `medianDuration` |
| averageDurations          | List of the average duration in seconds of a refresh.                  | `averageDuration`|

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/capacities/get-Workloads) for other properties available.

## Examples

### Test to ensure Power BI Capacity Workload schedules are enabled

```ruby
describe azure_power_bi_capacity_workloads do
  its('refreshSchedules') { should_not be empty }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Power BI Capacity Workloads are present
describe azure_power_bi_capacity_workloads do
  it { should_not exist }
end
# Should exist if the filter returns at least one Power BI Capacity Workloads
describe azure_power_bi_capacity_workloads do
  it { should exist }
end
```

## Azure Permissions
Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `Capacity.Read.All` role on the Azure Power BI Capacity you wish to test.
