---
title: About the azure_data_factory_pipeline_run_resource Resource
platform: azure
---

# azure_data_factory_pipeline_run_resource

Use the `azure_data_factory_pipeline_run_resource` InSpec audit resource to test the properties of an Azure pipeline runs.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md). For API related info : [`Azure pipeline runss Docs`](https://docs.microsoft.com/en-us/rest/api/datafactory/pipeline-runs/get).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group`, `run_id`, and `factory_name` are required parameters.

```ruby
describe azure_data_factory_pipeline_run_resource(resource_group: `RESOURCE_GROUP`, factory_name: `FACTORY_NAME`, run_id: `run_id`) do
  #...
end
```

## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in.                       |
| factory_name                   | The factory name.                                                                 |
| run_id            | The name of the pipeline runs. |

All the parameter sets are required for a valid query:

- `resource_group` , `factory_name`, and `run_id`.

## Properties

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| invokedBy.name                 | The unique resource names.                                            |
| pipelineName                   | The pipeline name.                                                              |
| status                         | The status of a pipeline run.                                                     |
| runId                          | Identifiers of a run.                                          |
| runStart                       | Start time of a pipeline run in ISO8601 format.                                               |
| runEnd                         | End time of a pipeline run in ISO8601 format.                                                 |
| runStart                       | The properties of the resource.                                                  |
## Examples

### Test that a pipeline runs exists

```ruby
describe azure_data_factory_pipeline_run_resource(resource_group: `RESOURCE_GROUP`, factory_name: `FACTORY_NAME`, run_id: `RUN_ID`) do
  it { should exist }
end
```

### Test that a pipeline runs does not exist

```ruby
describe azure_data_factory_pipeline_run_resource(resource_group: `RESOURCE_GROUP`, factory_name: `FACTORY_NAME`, run_id: 'should not exit') do
  it { should_not exist }
end
```

### Test properties of a pipeline runs

```ruby
describe azure_data_factory_pipeline_run_resource(resource_group: `RESOURCE_GROUP`, name: 'FACTORY_NAME', run_id: `RUN_ID`) do
  its('invokedBy.name') { should include 'Manual' }
  its('pipelineNames') { should include 'pipeline_name' }
  its('status') { should include 'Failed/Success' }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
