+++
title = "azure_power_bi_dataflow resource"

draft = false


[menu.azure]
title = "azure_power_bi_dataflow"
identifier = "inspec/resources/azure/azure_power_bi_dataflow resource"
parent = "inspec/resources/azure"
+++

Use the `azure_power_bi_dataflow` InSpec audit resource to test the properties of a single Azure Power BI dataflow.

## Azure REST API version, endpoint, and HTTP client parameters

{{< readfile file="content/reusable/md/inspec_azure_common_parameters.md" >}}

## Syntax

```ruby
describe azure_power_bi_dataflow(group_id: 'GROUP_ID', name: 'DATAFLOW_ID') do
  it  { should exist }
end
```

```ruby
describe azure_power_bi_dataflow(group_id: 'GROUP_ID', name: 'DATAFLOW_ID')  do
  it  { should exist }
end
```

## Parameters

`name` _(required)_

: The dataflow ID.

`group_id` _(required)_

: The workspace ID.

## Properties

`name`
: The dataflow name.

`objectId`
: The dataflow ID.

`description`
: The dataflow description.

`modelUrl`
: A URL to the dataflow definition file (model.json).

For properties applicable to all resources, such as `type`, `name`, `id`, and `properties`, refer to [`azure_generic_resource`](azure_generic_resource#properties).

Also, see the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/power-bi/dataflows/get-dataflows) for other available properties.

## Examples

Test that the Power BI dataflow name exists:

```ruby
describe azure_power_bi_dataflow(group_id: 'GROUP_ID', name: 'DATAFLOW_ID')  do
  it { should exist }
  its('name') { should eq 'DATAFLOW_NAME' }
end
```

## Matchers

{{< readfile file="content/reusable/md/inspec_matchers_link.md" >}}

### exists

Use `should` to test that the entity exists.

```ruby
describe azure_power_bi_dataflow(group_id: 'GROUP_ID', name: 'DATAFLOW_ID')  do
  it { should exist }
end
```

### not_exists

Use `should_not` to test if the entity does not exist.

```ruby
describe azure_power_bi_dataflow(group_id: 'GROUP_ID', name: 'DATAFLOW_ID')  do
  it { should_not exist }
end
```

## Azure permissions

Your [service principal](https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-service-principal-portal) must have the `Dataflow.Read.All` role on the Azure Power BI dataflow you wish to test.
