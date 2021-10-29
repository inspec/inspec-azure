---
title: About the azure_power_bi_capacity_workload Resource
platform: azure
---

# azure_power_bi_capacity_workload

Use the `azure_power_bi_capacity_workload` InSpec audit resource to test the properties related to Azure Power BI Capacity Workload.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client are used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`name` and `capacity_id` is a required parameter.

```ruby
describe azure_power_bi_capacity_workload(capacity_id: 'CAPACITY_ID', name: 'WORKLOAD_NAME') do
  it  { should exist }
end
```

```ruby
describe azure_power_bi_capacity_workload(capacity_id: 'CAPACITY_ID', name: 'WORKLOAD_NAME')  do
  it  { should exist }
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | The workload ID.                                  |
| capacity_id    | The capacity ID.                                                            |

The parameter set should be provided for a valid query:

- `name` and `capacity_id`

## Properties

| Property                   | Description                                                      |
|----------------------------|------------------------------------------------------------------|
| id                         | The object ID of the workload.                                |
| kind                       | The workload kind.                                            |
| name                       | Display name of workload.                                     |
| startTime                  | The start time of the window for which summary data exists.      |
| endTime                    | The end time of the window for which summary data exists.        |
| refreshCount               | The number of refreshes within the summary time window.          |
| refreshFailures            | The number of refresh failures within the summary time window.   |
| refreshesPerDay            | The number of refreshes (schedule+onDemand) per day within the summary time window with at most 60.|
| refreshSchedule.days       | Days to execute the refresh.                                     |
| refreshSchedule.enabled    | Is the refresh enabled.                                          |       


For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/capacities/get-workload-for-capacity) for other properties available.

## Examples

### Test that the Power BI Capacity workload schedule is enabled

```ruby
describe azure_power_bi_capacity_workload(capacity_id: 'CAPACITY_ID', name: 'WORKLOAD_NAME')  do
  its('refreshSchedules.enabled') { should be_truthy }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists

```ruby
# If the Power BI Capacity workload is found, it will exist
describe azure_power_bi_capacity_workload(capacity_id: 'CAPACITY_ID', name: 'WORKLOAD_NAME')  do
  it { should exist }
end
# if the Power BI Capacity workload is not found, it will not exist
describe azure_power_bi_capacity_workload(capacity_id: 'CAPACITY_ID', name: 'WORKLOAD_NAME')  do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `Capacity.Read.All` role on the Azure Power BI Capacity you wish to test.