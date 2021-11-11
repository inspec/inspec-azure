---
title: About the azure_data_factory_pipeline_run_resource Resource
platform: azure
---

# azure_data_factory_pipeline_run_resource

Use the `azure_data_factory_pipeline_run_resource` InSpec audit resource to test the properties of an Azure Data Factory pipeline run.

For additional information, see the [`Azure Data Factory pipeline runs API documentation`](https://docs.microsoft.com/en-us/rest/api/datafactory/pipeline-runs/query-by-factory).

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

```ruby
describe azure_data_factory_pipeline_run_resource(resource_group: `RESOURCE_GROUP`, factory_name: `FACTORY_NAME`, run_id: `RUN_ID`) do
  #...
end
```

## Parameters

`resource_group` _(required)_

Azure resource group that the targeted resource resides in.

`factory_name` _(required)_

The factory name.

`run_id` _(required)_

The name of the pipeline runs.

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

### Test properties of a pipeline runs

```ruby
describe azure_data_factory_pipeline_run_resource(resource_group: `RESOURCE_GROUP`, name: 'FACTORY_NAME', run_id: `RUN_ID`) do
  its('invokedBy.name') { should include 'INVOKED_BY_NAME' }
  its('pipelineNames') { should include 'PIPELINE_NAME' }
  its('status') { should include 'PIPELINE_STATUS' }
end
```

## Matchers

### Test that a pipeline runs exists

```ruby
describe azure_data_factory_pipeline_run_resource(resource_group: `RESOURCE_GROUP`, factory_name: `FACTORY_NAME`, run_id: `RUN_ID`) do
  it { should exist }
end
```

### Test that a pipeline runs does not exist

```ruby
describe azure_data_factory_pipeline_run_resource(resource_group: `RESOURCE_GROUP`, factory_name: `FACTORY_NAME`, run_id: 'RUN_ID') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
