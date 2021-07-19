---
title: About the azure_data_factories Resource
platform: azure
---

# azure_data_factories

Use the `azure_data_factories` InSpec audit resource to test properties related to data factories for a resource group or the entire subscription.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used.
For more information, refer to the resource pack [README](../../README.md). 
For api related info : [`Azure Data Factories Docs`](https://docs.microsoft.com/en-us/azure/data-factory/quickstart-create-data-factory-rest-api#create-a-data-factory).
## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_data_factories` resource block returns all Azure data factories, either within a Resource Group (if provided), or within an entire Subscription.
```ruby
describe azure_data_factories do
  #...
end
```
or
```ruby
describe azure_data_factories(resource_group: 'my-rg') do
  #...
end
```

## Properties

|Property       | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------|--------------------------------------------------------------------------------------|-----------------|
| name           | A list of the unique resource ids.                                                   | `name`            |
| ids            | A list of data factory names .                                | `id`       |
| tags          | A list of `tag:value` pairs defined on the resources.                                | `tag`          |
| provisioning_state             | State of Data Factories creation                               |        `provisioning_state`         |
| types             |   Types of all the data factories | `type` |
  
<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).
  
## Examples

### Test If Any Data Factories Exist in the Resource Group
```ruby
describe azure_data_factories(resource_group: 'MyResourceGroup') do
  it { should exist }
  its('names') { should include "factory_name" }
end
```
### exists
```ruby
# Should not exist if no Data Factory are in the resource group
describe azure_data_factories(resource_group: 'MyResourceGroup') do
  it { should_not exist }
end

```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
