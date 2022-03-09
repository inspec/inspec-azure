+++
title = "azure_sentinel_alert_rules Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_sentinel_alert_rules"
identifier = "inspec/resources/azure/azure_sentinel_alert_rules Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_sentinel_alert_rules` Chef InSpec audit resource to test properties of an Azure Sentinel alert rule for a resource group or the entire subscription.

For additional information, see the [`Azure Sentinel Alert Rules API documentation`](https://docs.microsoft.com/en-us/rest/api/datafactory/pipeline-runs/query-by-factory).

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

An `azure_sentinel_alert_rules` resource block returns all Azure Sentinel alerts rules, either within a Resource Group (if provided), or within an entire Subscription.

```ruby
describe azure_sentinel_alert_rules(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME') do
  #...
end
```

## Parameters

`resource_group` _(required)_

: The name of the resource group.

`workspace_name` _(required)_

: The name of the workspace.

## Properties

`names`
: A list of the unique resource names.

: **Field**: `name`

`ids`
: A list of alert_rule IDs .

: **Field**: `id`

`properties`
: A list of properties for the resource.

: **Field**: `properties`

`types`
: A list of types for each resource.

: **Field**: `type`

`severities`
: The list of severity for alerts created by this alert rule.

: **Field**: `severity`

`displayNames`
: The List of display name for alerts created by this alert rule.

: **Field**: `displayName`

`enableds`
: The list of flags which Determines whether this alert rule is enabled or disabled.

: **Field**: `enabled`

`kinds`
: The alert rule kind.

: **Field**: `kind`

`alertRuleTemplateNames`
: The Name of the alert rule template used to create this rule.

: **Field**: `alertRuleTemplateName`

{{% inspec_filter_table %}}

## Examples

**Test if properties match.**

```ruby
describe azure_sentinel_alert_rules(resource_group: resource_group, workspace_name: workspace_name) do
  its('names') { should include 'BuiltInFusion' }
  its('types') { should include 'Microsoft.SecurityInsights/alertRules' }
  its('kinds') { should include 'Fusion' }
  its('severities') { should include 'High' }
  its('enableds') { should include true }
  its('displayNames') { should include 'Advanced Multistage Attack Detection' }
  its('alertRuleTemplateNames') { should include 'f71aba3d-28fb-450b-b192-4e76a83015c8' }
end
```

**Test if any alert rules exist in the resource group.**

```ruby
describe azure_sentinel_alert_rules(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME') do
  it { should exist }
end
```

**Test that there aren't any alert rules in a resource group.**

```ruby
describe azure_sentinel_alert_rules(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

{{% azure_permissions_service_principal role="contributor" %}}
