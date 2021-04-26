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

```ruby
describe azure_policy_assignments.where{ enforcement_mode != 'Default' } do
    it {should_not exist}
    its('display_names') {should eq []}
end
```

## Properties

Please review the [Azure documentation](https://docs.microsoft.com/en-us/rest/api/policy/policyassignments/list#policyassignment) for a full description of properties.

| Property                | Filter           | Description                                                                              |
|-------------------------|------------------|------------------------------------------------------------------------------------------|
| ids                     | id               | The identity of the policy assignment (this is not the identity of the policy itself)    |
| identities              | identity         | The managed identity associated with the policy assignment.                              |
| locations               | location         | The location of the policy assignment. Only used when utilizing managed identity.        |
| names                   | name             | The name of the policy assignment                                                        |
| descriptions            | description      | This message will be part of response in case of policy violation.                       |
| display_names           | display_name     | The display name of the policy assignment.                                               |
| excluded_scopes         | excluded_scopes  | The scopes (resources/groups) which are excluded from this policy assignment             |
| enforcement_modes       | enforcement_mode | The policy assignment enforcement mode. Possible values are `Default` and `DoNotEnforce` |
| non_compliance_messages | non_compliance_messages | The messages that describe why a resource is non-compliant with the policy.       |
| parameters              | parameters       | Additional parameters                                                                    |
| definition_ids          | definition_id    | The ID of the policy that this assignment refers to                                      |
| scopes                  | scope            | The scope of the policy assignment                                                       |

## Examples

Check that all assigned policies are in enforcing mode

```ruby
describe azure_policy_assignments.where{ enforcement_mode == 'DoNotEnforce' } do
    it {should_not exist}
    its('display_names') {should eq []}
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
