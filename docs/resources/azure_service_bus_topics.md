---
title: About the azure_service_bus_topics Resource
platform: azure
---

# azure_service_bus_topics

Use the `azure_service_bus_topics` InSpec audit resource to test properties related to all Azure Service Bus Topics within a project.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_service_bus_topics` resource block returns all Azure Service Bus Topics within a project.

`name`, `namespace_name`, and `resource_group` are the required parameters.

```ruby
describe azure_service_bus_topics(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME') do
  #...
end
```

## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Service Bus Topics to test.                                    |
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| namespace_name | Name of the namespace where the topic resides in.                                |

The parameter set should be provided for a valid query:
- `resource_group` and `namespace_name`

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | A list of resource IDs.                                                | `id`             |
| names                          | A list of resource Names.                                              | `name`           |
| types                          | A list of the resource types.                                          | `type`           |
| properties                     | A list of Properties for all the Service Bus Topics.                   | `properties`     |
| maxSizeInMegabytes             | A list of maximum sizes of the topics.                                 | `maxSizeInMegabytes` |
| sizeInBytes                    | A list of sizes of the topics.                                         | `sizeInBytes`    |
| statuses                       | A list of the status of a messaging entity.                            | `status`         |
| countDetails                   | A list of message count details.                                       | `countDetails`   |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through Service Bus Topics by their names.

```ruby
azure_service_bus_topics(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME').names.each do |name|
  describe azure_service_bus_topic(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME', name: name) do
    it { should exist }
  end
end
```
### Test that there are Service Bus Topics that are successfully provisioned.

```ruby
describe azure_service_bus_topics(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME').where(status: 'Active') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Service Bus Topics are present
describe azure_service_bus_topics(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Service Bus Topics
describe azure_service_bus_topics(resource_group: 'RESOURCE_GROUP', namespace_name: 'SERVICE_BUS_NAMESPACE_NAME') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `reader` role on the subscription you wish to test.