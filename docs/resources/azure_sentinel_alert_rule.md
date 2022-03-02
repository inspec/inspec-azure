---
title: About the azure_sentinel_alert_rule Resource
platform: azure
---

# azure_sentinel_alert_rule

Use the `azure_sentinel_alert_rule` InSpec audit resource to test properties related to alert_rule for a resource group or the entire subscription.

## Azure REST API version, endpoint, and HTTP client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).
For api related info : [`Azure alert_rule Docs`](https://docs.microsoft.com/en-us/rest/api/securityinsights/stable/alert-rules/get).
## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_sentinel_alert_rules` resource block returns all Azure alert_rule, either within a Resource Group (if provided), or within an entire Subscription.

```ruby
describe azure_sentinel_alert_rule(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', rule_id: 'RULE_ID') do
  it { should exit }
end
```

## Parameters

`resource_group`, `workspace_name` and `rule_id` must be given as parameters.

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| workspace_name                 | Azure workspace Name for which alert_rule are being retrieved. |
| rule_id                        | Alert rule ID. |

## Properties

| Property                  | Description                       |
| ------------------------- | --------------------------------- |
| id                        | The id of the alert rule.         |
| name                      | The name of the alert rule.       |
| type                      | The type of the alert rule.       |
| kind                      | The kind of the alert rule.       |
| etag                      | The etag of the alert rule.       |
| properties                | The properties of the alert rule  |

## Examples

### Test if rule id exists

```ruby
describe azure_sentinel_alert_rule(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', rule_id: 'RULE_ID') do
  its('id') { should eq 'ALERRT_RULE_ID' }
end
```

### Test if rule name exists

```ruby
describe azure_sentinel_alert_rule(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', rule_id: 'RULE_ID') do
  its('name') { should eq 'ALERRT_RULE_NAME' }
end
```

### Test if rule kind is `Scheduled`

```ruby
describe azure_sentinel_alert_rule(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', rule_id: 'RULE_ID') do
  its('kind') { should eq 'Scheduled' }
end
```

### Test if rule type is `Microsoft.SecurityInsights/alertRules`

```ruby
describe azure_sentinel_alert_rule(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', rule_id: 'RULE_ID') do
  its('type') { should eq 'Microsoft.SecurityInsights/alertRules' }
end
```

### Test if the display name is present or not.

```ruby
describe azure_sentinel_alert_rule(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', rule_id: 'RULE_ID') do
  its('properties.displayName') { should eq "DISPLAY_NAME" }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# If we expect a resource to always exist
describe azure_sentinel_alert_rule(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', rule_id: 'RULE_ID') do
  it { should exist }
end

# If we expect a resource to never exist
describe azure_sentinel_alert_rule(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', rule_id: 'RULE_ID') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
