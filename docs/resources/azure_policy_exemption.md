---
title: About the azure_policy_exemption Resource
platform: azure
---

# azure_policy_exemption

Use the `azure_policy_exemption` InSpec audit resource to test properties related to a Azure Policy Exemption.

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

## Syntax

`name` must be given as a parameter and `resource_group` could be provided as an optional parameter
```ruby
describe azure_policy_exemption(resource_group: 'MyResourceGroup', name: '3b8b3f3bbec24cd6af583694') do
  it                                      { should exist }
  its('name')                             { should cmp '3b8b3f3bbec24cd6af583694' }
  its('type')                             { should cmp 'Microsoft.Authorization/policyExemptions' }
  its('properties.exemptionCategory')     { should cmp 'Waiver' }
  its('properties.policyAssignmentId')    { should cmp '/subscriptions/ae640e6b-ba3e-4256-9d62-2993eecfa6f2/providers/Microsoft.Authorization/policyAssignments/CostManagement' }
  its('systemData.createdByType')         { should cmp 'User' }
end
```
```ruby
describe azure_policy_exemption(name: '3b8b3f3bbec24cd6af583694') do
  it  { should exist }
end
```
## Parameters

| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| name           | Name of the Azure Policy Exemption to test.                                      |
| resource_group | This is an optional parameter. Azure resource group that the targeted resource resides in. `MyResourceGroup`|

The parameter set should be provided for a valid query:
- `name`
- `resource_group` (optional) and `name` 

## Properties

| Property                      | Description                                                      |
|-------------------------------|------------------------------------------------------------------|
| id                            | Resource ID.                                                     |
| name                          | Policy Exemption Name.                                           |
| type                          | Resource type.                                                   |
| properties.policyAssignmentId | The ID of the policy assignment that is being exempted.          |
| properties.policyDefinitionReferenceIds| The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition. |
| properties.exemptionCategory  | The policy exemption category. Possible values are Waiver and Mitigated. |
| properties.displayName        | The display name of the policy exemption.                        |
| properties.description        | The description of the policy exemption.                         |
| systemData.createdBy          | The identity that created the resource.                          |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/policy/policy-exemptions/get) for other properties available.
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test <>
```ruby
describe azure_policy_exemption(name: '3b8b3f3bbec24cd6af583694') do
  its('properties.exemptionCategory') { should eq 'Waiver' }
end
```
### Test <>
```ruby
describe azure_policy_exemption(resource_group: 'MyResourceGroup', name: '3b8b3f3bbec24cd6af583694') do
  its('properties.policyDefinitionReferenceIds') { should include 'Limit_Skus' }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](/inspec/matchers/).

### exists
```ruby
# If a policy exemption is found it will exist
describe azure_policy_exemption(name: '3b8b3f3bbec24cd6af583694') do
  it { should exist }
end

# policy exemptions that aren't found will not exist
describe azure_policy_exemption('3b8b3f3bbec24cd6af583694') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.