---
title: About the azure_data_factory_pipeline_run_resources Resource
platform: azure
---

# azure_data_factory_pipeline_run_resources

Use the `azure_data_factory_pipeline_run_resources` InSpec audit resource to test the properties related to Pipeline Runs for a resource group or the entire subscription.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter. If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md). For information on API, refer [`Azure Pipeline Docs`](https://docs.microsoft.com/en-us/rest/api/datafactory/pipeline-runs/query-by-factory).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_data_factory_pipeline_run_resources` resource block returns all Azure Pipeline Runs

```ruby
describe azure_data_factory_pipeline_run_resources(resource_group: `RESOURCE_GROUP`, factory_name: 'FACTORY_NAME') do
  #...
end
```

`resource_group` and `factory_name` are required parameters.

## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in.                       |
| factory_name                   | Azure factory name for which Pipeline Runs are retrieved.                        |

## Properties

| Property        | Description                                            | Filter Criteria<superscript>*</superscript> |
|-----------------|---------------------------------------------------------|-----------------------|
| invokedBy_names                 | A list of the unique resource names.                                      | `invokedBy_name`      |
| pipelineNames                   | A list of the pipeline names.                                             | `pipelineName`        |
| statuses                        | The status of a pipeline run.                                             | `status`              |
| runIds                          | The list of Identifiers of run.                                           | `runId`               |
| runStart                        | The list of start time of a pipeline run in ISO8601 format.               | `runStart`            |
| runEnd                          | The list of end time of a pipeline run in ISO8601 format.                 | `runEnd`              |

<superscript>*</superscript> For information on how to use filter criteria on plural resources, refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test if any Pipeline Runs exist in the resource group

```ruby
describe azure_data_factory_pipeline_run_resources(resource_group: `RESOURCE_GROUP`, factory_name: 'FACTORY_NAME') do
  it { should exist }
end
```

### Test that there aren't any Pipeline Runs in a resource group

```ruby
# Should not exist if no Pipeline Runs are in the resource group
describe azure_data_factory_pipeline_run_resources(resource_group: `RESOURCE_GROUP`, factory_name: 'FACTORY_NAME') do
  it { should_not exist }
end
```

### Filter Pipeline Runs in a resource group by properties

```ruby
describe azure_data_factory_pipeline_run_resources(resource_group: `RESOURCE_GROUP`, factory_name: 'FACTORY_NAME') do
  its('invokedBy_names') { should include 'Manual' }
  its('pipelineNames') { should include 'pipeline_name' }
  its('statuses') { should include 'Failed/Success' }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
