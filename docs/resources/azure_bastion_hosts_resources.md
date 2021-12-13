---
title: About the azure_bastion_hosts_resources Resource
platform: azure
---

# azure_bastion_hosts_resources

Use the `azure_bastion_hosts_resources` InSpec audit resource to test properties of Azure Bastion hosts for a resource group or the entire subscription.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/virtualnetwork/bastion-hosts/list) for  properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).
## Syntax

An `azure_bastion_hosts_resource` resource block returns all Azure Bastion hots, either within a Resource Group (if provided)

```ruby
describe azure_bastion_hosts_resources(resource_group: 'my-rg') do
  ..
end
```

## Parameters

`resource_group` _(optional)_

The name of the resource group.

## Properties

|Property             | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|---------------------|--------------------------------------------------------------------------------------|---------------------------------------------|
| name                | A list of the unique resource names.                                                 | `name`                                      |
| ids                 | A list of Bastion hosts IDs.                                                         | `id`                                        |
| tags                | A list of `tag:value` pairs defined on the resources.                                | `tags`                                      |
| provisioning_states | State of Bastion hosts creation                                                      | `provisioningState`                         |
| types               | Types of all the Bastion hosts.                                                      | `type`                                      |
| properties          | Properties of all the Bastion hosts.                                                 | `properties`                                |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Ensure that the Bastion hosts resource has is from same type

```ruby
describe azure_bastion_hosts_resources(resource_group: 'RESOURCE_GROUP') do
  its('type') { should eq 'Microsoft.Network/bastionHosts' }
end
```
### Ensure that the Bastion hosts resource is in successful state

```ruby
describe azure_bastion_hosts_resources(resource_group: 'RESOURCE_GROUP') do
  its('provisioning_states') { should include('Succeeded') }
end
```

### Ensure that the Bastion hosts resource is from same location

```ruby
describe azure_bastion_hosts_resources(resource_group: 'RESOURCE_GROUP') do
  its('location') { should include df_location }
end
```

### Test if any Bastion hosts exist in the resource group

```ruby
describe azure_bastion_hosts_resources(resource_group: 'RESOURCE_GROUP') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Bastion hots are in the resource group
describe azure_bastion_hosts_resources(resource_group: 'RESOURCE_GROUP') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
