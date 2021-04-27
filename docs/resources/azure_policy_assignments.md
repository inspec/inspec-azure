---
title: About the azure_policy_assignments Resource
platform: azure
---

## azure_policy_assignments

Use the `azure_policy_assignments` InSpec resource to examine assignments of Azure policy to resources and resource groups.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used.
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

Please review the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/policy/policyassignments/list#policyassignment) for a full description of properties.

| Property             | Filter              | Description                                                                              |
|----------------------|---------------------|------------------------------------------------------------------------------------------|
| ids                  | id                  | The ID of this policy assignment                                                         |
| types                | type                | The Azure resource type                                                                  |
| names                | name                | The names of the policy assignments                                                      |
| locations            | location            | The locations of the policy assignments                                                  |
| tags                 | tags                | The tags of the policy assignments                                                       |
| displayNames         | displayName         | The display names of the policy assignments                                              |
| policyDefinitionIds  | policyDefinitionId  | The IDs of the policies being assigned by these policy assignments                       |
| scopes               | scope               | The scope of the policy assignments (which resources they are being attached to)         |
| notScopes            | notScopes           | The scopes which are excluded from these policy assignments (blocks inheritance)         |
| parameters           | parameters          | The override parameters passed to the base policy by this assignment                     |
| enforcementMode      | enforcementModes    | The enforment modes of these policy assignments                                          |
| assignedBys          | assignedBy          | The ID's that assigned these policies                                                    |
| parameterScopes      | parameterScopes     | Unknown - no data observed in this field in the wild                                     |
| created_bys          | created_by          | The ID's that created these policy assignments                                           |
| createdOns           | createdOn           | The dates these policy assignments were created (as a ruby Time object)                  |
| updatedBys           | updatedBy           | The ID's that updated these policy assignments                                           |
| updatedOns           | updatedOn           | The dates these policy assignments were updated (as a ruby Time object)                  |
| identityPrincipalIds | identityPrincipalId | The principal ID's of the associated managed identities                                  |
| identityTenantIds    | identityTenantId    | The tenant ID's of the associated managed identities                                     |
| identityTypes        | identityType        | The identity types of the associated managed identities                                  |

## Examples

Check that all assigned policies are in enforcing mode

```ruby
describe azure_policy_assignments.where{ enforcement_mode == 'DoNotEnforce' } do
    it {should_not exist}
    its('display_names') {should eq []}
end
```

Check that no policies were modified in the last 30 days

```ruby
last_30_days = Time.now() - (60*60*24*30)

describe azure_policy_assignments.where{ (updatedOn > last_30_days) || (createdOn > last_30_days) } do
  it {should_not exist}
  its('ids') {should eq []}
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
