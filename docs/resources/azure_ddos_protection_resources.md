---
title: About the azure_ddos_protection_resources Resource
platform: azure
 ---

# azure_ddos_protection_resources

Use the `azure_ddos_protection_resources` InSpec audit resource to test properties of DDoS protection plans in a resource group.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_ddos_protection_resources` resource block returns all Azure bastion hosts, either within a Resource Group (if provided)

```ruby
describe azure_ddos_protection_resources(resource_group: 'RESOURCE_GROUP') do
   #....
end
```

## Parameters

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in.                      |

## Properties

|Property          | Description                                                                          | Filter Criteria<superscript>*</superscript> |
|------------------|--------------------------------------------------------------------------------------|---------------------------------------------|
| names            | A list of the unique resource names.                                                 | `name`                                      |
| ids              | A list of DDoS protection plan IDs.                                                  | `id`                                        |
| virtual_networks | The list of virtual networks associated with the DDoS protection plan resource.      | `virtual_networks`                          |
| provisioning_states | The provisioning states of the DDoS protection plans.                             | `provisioning_state`                        |
| types            | The types of all the DDoS protection plans.                                          | `type`                                      |
|resource_guids    | The resource GUID property of the DDoS protection plan resource. It uniquely identifies the resource, even if the user changes its name or migrate the resource across subscriptions or resource groups. |`resource_guid`|


<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

Also, refer to the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/virtualnetwork/ddos-protection-plans/list) for all available properties.
Access any attribute in the response by separating the key names with a period (`.`).

## Examples

### Ensure that the DDoS protection plan resource is in successful state

```ruby
describe azure_ddos_protection_resources(resource_group: 'RESOURCE_GROUP') do
  its('provisioning_states') { should include('Succeeded') }
end
```

### Ensure that a DDoS protection plan resource is from a location

```ruby
describe azure_ddos_protection_resources(resource_group: 'RESOURCE_GROUP') do
  its('location') { should include `RESOURCE_LOCATION` }
end
```
### Test if any DDoS protection plan exists in the resource group

```ruby
describe azure_ddos_protection_resources(resource_group: 'RESOURCE_GROUP') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no bastion hots are in the resource group
describe azure_ddos_protection_resources(resource_group: 'RESOURCE_GROUP') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
