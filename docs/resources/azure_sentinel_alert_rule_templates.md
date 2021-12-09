---
title: About the azure_sentinel_alert_rule_templates Resource
platform: azure
   ---

# azure_sentinel_alert_rule_templates

Use the `azure_sentinel_alert_rule_templates` InSpec audit resource to test properties related to alert rule templates for a resource group or the entire subscription.

See the [`Azure alert rule templates documentation`](https://docs.microsoft.com/en-us/rest/api/securityinsights/alert-rule-templates/list) for additional information.

## Azure Rest API Version, Endpoint, And HTTP Client Parameters

This resource interacts with API versions supported by the resource provider.
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

An `azure_sentinel_alert_rule_templates` resource block returns all Azure alert rule templates, either within a Resource Group (if provided), or within an entire Subscription.

```ruby
describe azure_sentinel_alert_rule_templates(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME') do
  #...
end
```

`resource_group` and `workspace_name` are required parameters.


## Parameters

| Name                           | Description                                                                       |
   |-----------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in.                       |
| workspace_name                 | Azure workspace Name for which alert rule templates are being retrieved.|

## Properties

| Property        | Description                                            | Filter Criteria<superscript>*</superscript> |
|-----------------|--------------------------------------------------------|-----------------|
| names           | A list of the unique resource names.                   | `name`          |
| ids             | A list of alert rule templates IDs .                   | `id`            |
| properties      | A list of properties for the resource                  | `properties`          |
| types           | A list of types for each resource.                     | `type`          |
| severities      | The severity for alerts created by this alert rule.    | `severity` |
| statuses        | The status of the alert rule.                          | `status` |
| triggerThresholds | The email of the user the incident is assigned to.         | `triggerThreshold` |
| displayNames| The user principal name of the user the incident is assigned to. | `displayName` |
| triggerOperators | The name of the user the incident is assigned to.     | `triggerOperator` |
|queryPeriods| The List of period (in ISO 8601 duration format) that this alert rule looks at. |`queryPeriod`|
|queryFrequencies| The List of frequency (in ISO 8601 duration format) for this alert rule to run.|`queryFrequency`|

<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Test if properties matches

```ruby
describe azure_sentinel_alert_rule_templates(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME') do
   its('names') { should include 'RESOURCE_NAME' }
   its('types') { should include 'Microsoft.SecurityInsights/AlertRuleTemplates' }
   its('kinds') { should include 'ALERT_RULE_KIND' }
   its('triggerThresholds') { should include INTEGER }
   its('statuses') { should include 'STATUS' }
   its('severities') { should include 'ALERT_SEVERITY' }
   its('queryFrequencies') { should include 'FREQUENCY' }
   its('queryPeriods') { should include 'PERIOD' }
   its('triggerOperators') { should include 'OPERATOR' }
   its('displayNames') { should include 'ALERT_RULE_DISPLAY_NAME' }
end
```

### Test if any alert rule templates exist in the resource group

```ruby
describe azure_sentinel_alert_rule_templates(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME') do
  it { should exist }
end
```

### Test that there aren't any alert rule templates in a resource group

```ruby
# Should not exist if no alert rule templates are in the resource group
describe azure_sentinel_alert_rule_templates(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME') do
  it { should_not exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
