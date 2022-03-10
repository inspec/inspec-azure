+++
title = "azure_power_bi_dataflows Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_power_bi_dataflows"
identifier = "inspec/resources/azure/azure_power_bi_dataflows Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_power_bi_dataflows` InSpec audit resource to test the properties related to all Azure Power BI dataflows.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_power_bi_dataflows` resource block returns all Azure Power BI dataflows.

```ruby
describe azure_power_bi_dataflows(group_id: 'GROUP_ID') do
  #...
end
```

## Parameters

`group_id`
: The Workspace ID.

## Properties

`objectIds`

: List of all Power BI dataflow IDs.

: **Field**: `objectId`

`names`

: List of all the Power BI dataflow names.

: **Field**: `name`

`descriptions`

: List of all the Power BI dataflow descriptions.

: **Field**: `descriptio

`modelUrls`

: List of all URLs to the dataflow definition file

: **Field**: `modelUrl`


{{% inspec_filter_table %}}

## Examples

**Test to ensure Power BI Dataflow for Finance exists.**

```ruby
describe azure_power_bi_dataflows(group_id: 'GROUP_ID').where(name: 'DATAFLOW_NAME') do
  it { should exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
# Should not exist if no Power BI dataflows are present

describe azure_power_bi_dataflows(group_id: 'GROUP_ID') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Power BI dataflows

describe azure_power_bi_dataflows(group_id: 'GROUP_ID') do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `Dataflow.Read.All` role on the Azure Power BI Dataflow you wish to test.