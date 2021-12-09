---
title: About the azure_sentinel_alert_rule_template Resource
platform: azure
   ---

# azure_sentinel_alert_rule_template

Use the `azure_sentinel_alert_rule_template` InSpec audit resource to test properties of an Azure Sentinel alert rule template.

See the [`Azure alert rule templates documentation`](https://docs.microsoft.com/en-us/rest/api/securityinsights/alert-rule-templates/list) for additional information.

## Azure REST API version, endpoint, and HTTP client parameters

This resource interacts with api versions supported by the resource provider.
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

`resource_group`, `alert_rule_template_id`, and `workspace_name` are required parameters.

```ruby
describe azure_sentinel_alert_rule_template(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', alert_rule_template_id: 'ALERT_RULE_TEMPLATE_ID') do
  #...
end
```

## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in.     |
| workspace_name                 | Name for the workspace_name that you want to create your Sentinel alert rule template in. |
| alert_rule_template_id         | The Sentinel alert rule template name. |

All the parameter sets needs be provided for a valid query:

- `resource_group`
- `workspace_name`
- `alert_rule_template_id`

## Properties

| Name                           | Description                                                                      |
|--------------------------------|----------------------------------------------------------------------------------|
| name                           | Name of the Azure resource to test.                                              |
| id                             | The Sentinel alert rule template type.                                           |
| properties                     | The Properties of the Resource.                                                  |
| type | Azure resource type. |
| kind | The alert rule kind. |
| properties.severity | The severity for alerts created by this alert rule. |
| properties.status| The alert rule template status. |
| properties.triggerThreshold | The threshold triggers this alert rule.  |
| properties.displayName| The display name for alert rule template.  |
| properties.triggerOperator | The operation against the threshold that triggers alert rule.  |
| properties.queryPeriod | The period (in ISO 8601 duration format) that this alert rule looks at. |
| properties.queryFrequency | The frequency (in ISO 8601 duration format) for this alert rule to run. |
## Examples

### Test if properties match

 ```ruby
describe azure_sentinel_alert_rule_template(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', alert_rule_template_id: 'ALERT_RULE_TEMPLATE_ID') do
  its('name') { should eq 'RESOURCE_NAME' }
  its('type') { should eq 'Microsoft.SecurityInsights/AlertRuleTemplates' }
  its('kind') { should eq 'ALERT_RULE_KIND' }
  its('properties.triggerThreshold') { should eq INTEGER }
  its('properties.status') { should eq 'STATUS' }
  its('properties.displayName') { should eq 'ALERT_RULE_DISPLAY_NAME' }
  its('properties.triggerOperator') { should eq 'OPERATOR' }
  its('properties.queryPeriod') { should eq 'PERIOD' }
  its('properties.queryFrequency') { should eq 'FREQUENCY' }
  its('properties.severity') { should eq 'ALERT_SEVERITY' }
end
 ```


### Test that a Sentinel alert rule template exists

```ruby
describe azure_sentinel_alert_rule_template(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', alert_rule_template_id: 'ALERT_RULE_TEMPLATE_ID') do
  it { should exist }
end
```

### Test that a Sentinel alert rule template does not exist

```ruby
describe azure_sentinel_alert_rule_template(resource_group: 'RESOURCE_GROUP', workspace_name: 'WORKSPACE_NAME', alert_rule_template_id: 'ALERT_RULE_TEMPLATE_ID') do
  it { should_not exist }
end
   ```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.