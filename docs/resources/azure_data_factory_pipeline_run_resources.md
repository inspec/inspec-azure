---
title: About the azure_data_factory_pipeline_run_resources Resource
platform: azure
---

# azure_data_factory_pipeline_run_resources

Use the `azure_data_factory_pipeline_run_resources` InSpec audit resource to test the properties multiple Azure Data Factory pipeline runs for a resource group or the entire subscription.

For additional information, see the [`Azure Data Factory pipeline runs API documentation`](https://docs.microsoft.com/en-us/rest/api/datafactory/pipeline-runs/query-by-factory).

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter. If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_data_factory_pipeline_run_resources` resource block returns all Azure Data Factory pipeline runs.

```ruby
describe azure_data_factory_pipeline_run_resources(resource_group: `RESOURCE_GROUP`, factory_name: 'FACTORY_NAME') do
  #...
end
```

## Parameters

`resource_group` _(required)_

Azure resource group that the targeted resource resides in.

`factory_name` _(required)_

Azure factory name for which pipeline runs are retrieved.


## Properties

| Property        | Description                                            | Filter Criteria<superscript>*</superscript> |
|-----------------|---------------------------------------------------------|-----------------------|
| invokedBy_names                 | A list of the unique resource names.                                      | `invokedBy_name`      |
| pipelineNames                   | A list of the pipeline names.                                             | `pipelineName`        |
| statuses                        | The statuses of the pipeline runs.                                             | `status`              |
| runIds                          | The list of identifiers of runs.                                           | `runId`               |
| runStart                        | The list of start times of pipeline runs in ISO8601 format.               | `runStart`            |
| runEnd                          | The list of end times of pipeline runs in ISO8601 format.                 | `runEnd`              |

<superscript>*</superscript> For information on how to use filter criteria on plural resources, refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Filter pipeline runs in a resource group by properties

```ruby
describe azure_data_factory_pipeline_run_resources(resource_group: `RESOURCE_GROUP`, factory_name: 'FACTORY_NAME') do
  its('invokedBy_names') { should include 'INVOKED_BY_NAME' }
  its('pipelineNames') { should include 'PIPELINE_NAME' }
  its('statuses') { should include 'PIPELINE_STATUS' }
end
```

## Matchers

### Test if any pipeline runs exist in the resource group

```ruby
describe azure_data_factory_pipeline_run_resources(resource_group: `RESOURCE_GROUP`, factory_name: 'FACTORY_NAME') do
  it { should exist }
end
```

### Test that there aren't any pipeline runs in a resource group

```ruby
# Should not exist if no pipeline runs are in the resource group
describe azure_data_factory_pipeline_run_resources(resource_group: `RESOURCE_GROUP`, factory_name: 'FACTORY_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
