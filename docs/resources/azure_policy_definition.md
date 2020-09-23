---
title: About the azure_policy_definition Resource
platform: azure
---

# azure_policy_definition

Use the `azure_policy_definition` InSpec audit resource to test properties and configuration of an Azure policy definition.

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

`name` or the `resource_id` must be given as a parameter.
```ruby
describe azure_policy_definition(name: 'my_policy') do
  it { should exist }
end
```
```ruby
describe azure_policy_definition(resource_id: '/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}') do
  it { should exist }
end
```
## Parameters

| Name                                  | Description |
|---------------------------------------|-------------|
| name                                  | Name of the policy definition. `policyDefinitionName` |
| built_in                              | Indicates whether the policy definition is built-in. Optional. Defaults to `false` if not supplied. This should not be used when `resource_id` is provided. |
| resource_id                           | The unique resource ID. `/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `name`
- `name` and `built_in`

## Properties

| Property                  | Description |
|---------------------------|-------------|
| properties.description    | The policy definition description. |
| properties.displayName    | The display name of the policy definition. |
| properties.policyType     | The type of policy definition. Possible values are `NotSpecified`, `BuiltIn`, `Custom`, and `Static`. |
| properties.policyRule     | The policy rule. |


For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/resources/policydefinitions/get#policydefinition) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`), eg. `properties.<attribute>`.

## Examples

### Test a Policy Definition Display Name
```ruby
describe azure_policy_definition(name: 'my_policy') do
  its('properties.displayName') { should cmp "Enforce 'owner' tag on resource groups" }
end
```
### Test a Policy Definition Rule
```ruby
describe azure_policy_definition(name: 'my_policy', built_in: true ) do
  its('properties.policyRule.then.effect') { should cmp 'deny' }
end
```    
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### custom
Test if a policy definition type is `Custom` or not.
```ruby
describe azure_policy_definition(name: 'my_policy') do
  it { should be_custom }
end
```
### exists
```ruby
# If we expect a resource to always exist
describe azure_policy_definition(name: 'my_policy', built_in: true ) do
  it { should exist }
end
# If we expect a resource to never exist
describe azure_policy_definition(name: 'my_policy') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
