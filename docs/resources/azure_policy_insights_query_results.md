---
title: About the azure_policy_insights_query_results Resource
platform: azure
---

# azure_policy_insights_query_results

Use the `azure_policy_insights_query_results` InSpec audit resource to test properties and configuration of multiple Azure Policy Insights query results.

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

An `azure_policy_insights_query_results` resource block returns all policy insights query results, either compliant, or not within a subscription.

```ruby
describe azure_policy_insights_query_results do
  it { should exist }
end
```

or

```ruby
describe azure_policy_insights_query_results do
  it { should exist }
end
```

## Parameters

## Properties

|Property       | Description                                                                               | Filter Criteria<superscript>*</superscript> |
|---------------|-------------------------------------------------------------------------------------------|-----------------|
| resource_ids               | A list of the unique resource IDs.                                            | `resource_id`        |
| policy_assignment_ids       | A list of all Policy assignment IDs.                                         | `policyAssignment_id`|
| policy_definition_ids       | A list of all Policy definition IDs.                                         | `policyDefinition_id`|
| is_compliant               | A list of boolean flags which states whether the resource is compliant or not.| `is_compliant`       |
| subscription_ids           | A list of Subscription IDs.                                                   | `subscription_id`    |
| resource_types             | A list of Resource types.                                                     | `resource_type`      |
| resource_locations         | A list of Resource locations.                                                 | `resource_location`  |
| resource_groups            | A list of Resource group names.                                               | `resource_group`     |
| resource_tags              | A list of resource tags.                                                      | `resource_tags`      |
| policy_assignment_names     | A list of Policy assignment names.                                           | `policy_assignment_name` |
| policy_definition_names     | A list of Policy definition names.                                           | `policy_definition_name` |
| policy_assignment_scopes    | A list of Policy assignment scopes.                                          | `policy_assignment_scope` |
| policy_assignment_parameters | A list of policy assignment parameter                                       | `policy_assignment_parameters` |
| policy_definition_actions   | A list of Policy definition actions.                                         | `policy_definition_action` |
| policy_definition_categories| A list of Policy definition categories.                                      | `policy_definition_category` |
| management_group_ids        | A list of management group IDs.                                              | `management_group_ids` |
| compliance_states          | A list compliance state of the resource.                                      | `compliance_state` |
| compliance_reason_codes | A list of reason codes recorded for failure                                      | `compliance_reason_code` |

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Check if a specific resource type is present

```ruby
describe azure_policy_insights_query_results do
  its('resource_types')  { should include 'Microsoft.VirtualMachineImages/imageTemplates' }
end
```
### Filters the results to include only those Policy Insights query results which include the given resource location

```ruby
describe azure_policy_insights_query_results.where(resource_location: 'RESOURCE_LOCATION') do
  it { should exist }
end
```
## Filters the results to include only the compliant Policy Insights query results

```ruby
describe azure_policy_insights_query_results.where(is_compliant: true) do
  it { should exist }
  its('count') { should be 120  }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

The control will pass if the filter returns at least one result. Use `should_not` if you expect zero matches.

```ruby
describe azure_policy_insights_query_results do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
