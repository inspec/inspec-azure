+++
title = "azure_data_factory_pipeline_run_resources Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_data_factory_pipeline_run_resources"
identifier = "inspec/resources/azure/azure_data_factory_pipeline_run_resources Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_data_factory_pipeline_run_resources` InSpec audit resource to test the properties of multiple Azure Data Factory pipeline runs for a resource group or the entire subscription.

For additional information, see the [`API documentation on Azure Data Factory pipeline runs`](https://docs.microsoft.com/en-us/rest/api/datafactory/pipeline-runs/query-by-factory).

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_data_factory_pipeline_run_resources` resource block returns all Azure Data Factory pipeline runs.

```ruby
describe azure_data_factory_pipeline_run_resources(resource_group: `RESOURCE_GROUP`, factory_name: 'FACTORY_NAME') do
  #...
end
```

## Parameters

`resource_group` _(required)_

: Azure resource group where the targeted resource resides.

`factory_name` _(required)_

: Azure factory name for which pipeline runs are retrieved.

## Properties

`invokedBy_names`
: A list of the unique resource names.

: **Field**: `invokedBy_name`

`pipelineNames`
: A list of the pipeline names.

: **Field**: `pipelineName`

`statuses`
: The statuses of the pipeline runs.

: **Field**: `status`

`runIds`
: The list of identifiers of runs.

: **Field**: `runId`

`runStart`
: The list of start times of pipeline runs in ISO8601 format.

: **Field**: `runStart`

`runEnd`
: The list of end times of pipeline runs in ISO8601 format.

: **Field**: `runEnd`

{{% inspec_filter_table %}}

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
# Should not exist if no pipeline runs are in the resource group.

describe azure_data_factory_pipeline_run_resources(resource_group: `RESOURCE_GROUP`, factory_name: 'FACTORY_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="contributor" %}}
