+++
title = "azure_sentinel_alert_rule Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_sentinel_alert_rule"
identifier = "inspec/resources/azure/azure_sentinel_alert_rule Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_sentinel_alert_rule` InSpec audit resource to test properties of an Azure Sentinel alert rule for a resource group or the entire subscription.

For additional information, see the [`Azure Sentinel Alert Rules API documentation`](https://docs.microsoft.com/en-us/rest/api/datafactory/pipeline-runs/query-by-factory).

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_sentinel_alert_rule` resource block returns all Azure alert_rule, either within a Resource Group (if provided), or within an entire Subscription.

```ruby
describe azure_sentinel_alert_rule(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', rule_id: 'RULE_ID') do
  it { should exit }
end
```

## Parameters

`resource_group` _(required)_

: Azure resource group that the targeted resource resides in.

`workspace_name` _(required)_

: Azure workspace Name for which alert rule are being retrieved.

`rule_id` _(required)_

: Alert rule ID.


## Properties

`id`
: The ID of the alert rule.

`name`
: The name of the alert rule.

`type`
: The type of the alert rule.

`kind`
: The kind of the alert rule.

`etag`
: The etag of the alert rule.

`properties`
: The properties of the alert rule.

## Examples

**Test if the rule ID exists.**

```ruby
describe azure_sentinel_alert_rule(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', rule_id: 'RULE_ID') do
  its('id') { should eq 'ALERRT_RULE_ID' }
end
```

**Test if the rule name exists.**

```ruby
describe azure_sentinel_alert_rule(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', rule_id: 'RULE_ID') do
  its('name') { should eq 'ALERRT_RULE_NAME' }
end
```

**Test if the rule kind is `Scheduled`.**

```ruby
describe azure_sentinel_alert_rule(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', rule_id: 'RULE_ID') do
  its('kind') { should eq 'Scheduled' }
end
```

**Test if the rule type is `Microsoft.SecurityInsights/alertRules`.**

```ruby
describe azure_sentinel_alert_rule(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', rule_id: 'RULE_ID') do
  its('type') { should eq 'Microsoft.SecurityInsights/alertRules' }
end
```

**Test if the display name is present or not.**

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

{{% azure_permissions_service_principal role="contributor" %}}
