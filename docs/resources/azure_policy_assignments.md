---
title: About the azure_policy_assignments Resource
platform: azure
---

# azure_policy_assignments

Use the `azure_policy_assignments` InSpec resource to examine assignments of Azure policy to resources and resource groups.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to the [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

```ruby
describe azure_policy_assignments do
  it { should exist }
end
```

## Properties

Please review the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/policy/policyassignments/list#policyassignment) for a full description of the available properties.

| Property             | Description                                                                              | Filter              |
|----------------------|------------------------------------------------------------------------------------------|---------------------|
| ids                  | The ID of this policy assignment                                                         | id                  |
| types                | The Azure resource type                                                                  | type                |
| names                | The names of the policy assignments                                                      | name                |
| locations            | The locations of the policy assignments                                                  | location            |
| tags                 | The tags of the policy assignments                                                       | tags                |
| displayNames         | The display names of the policy assignments                                              | displayName         |
| policyDefinitionIds  | The IDs of the policies being assigned by these policy assignments                       | policyDefinitionId  |
| scopes               | The scope of the policy assignments (which resources they are being attached to)         | scope               |
| notScopes            | The scopes which are excluded from these policy assignments (blocks inheritance)         | notScopes           |
| parameters           | The override parameters passed to the base policy by this assignment                     | parameters          |
| enforcementMode      | The enforcement modes of these policy assignments                                        | enforcementModes    |
| assignedBys          | The IDs that assigned these policies                                                     | assignedBy          |
| parameterScopes      | Unknown - no data observed in this field in the wild                                     | parameterScopes     |
| created_bys          | The IDs that created these policy assignments                                            | created_by          |
| createdOns           | The dates these policy assignments were created (as a Ruby Time object)                  | createdOn           |
| updatedBys           | The IDs that updated these policy assignments                                            | updatedBy           |
| updatedOns           | The dates these policy assignments were updated (as a Ruby Time object)                  | updatedOn           |
| identityPrincipalIds | The principal IDs of the associated managed identities                                   | identityPrincipalId |
| identityTenantIds    | The tenant IDs of the associated managed identities                                      | identityTenantId    |
| identityTypes        | The identity types of the associated managed identities                                  | identityType        |

## Examples

**Check that all assigned policies are in enforcing mode.**

```ruby
describe azure_policy_assignments.where{ enforcement_mode == 'DoNotEnforce' } do
    it {should_not exist}
    its('display_names') {should eq []}
end
```

**Check that no policies were modified in the last 30 days.**

```ruby
last_30_days = Time.now() - (60*60*24*30)

describe azure_policy_assignments.where{ (updatedOn > last_30_days) || (createdOn > last_30_days) } do
  it {should_not exist}
  its('ids') {should eq []}
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
