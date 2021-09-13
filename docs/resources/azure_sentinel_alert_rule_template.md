---
title: About the azure_sentinel_alert_rule_template Resource
platform: azure
   ---

# azure_sentinel_alert_rule_template

Use the `azure_sentinel_alert_rule_template` InSpec audit resource to test properties of an Azure sentinel_alert_rule_template.

## Azure REST API version, endpoint, and HTTP client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).
For api related info : [`Azure sentinel_alert_rule_template Docs`](https://docs.microsoft.com/en-us/rest/api/securityinsights/alert-rule-templates/get).


## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group` and `alert_rule_template_id`, `workspace_name` must be given as parameters.

   ```ruby
   describe azure_sentinel_alert_rule_template(resource_group: resource_group, workspace_name: workspace_name, alert_rule_template_id: alert_rule_template_id) do
     
   end
   ```

## Parameters

| Name                           | Description                                                                       |
   |--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| workspace_name                           | Name for the workspace_name that you want to create your sentinel_alert_rule_template in..                                                                 |
| alert_rule_template_id                 | The sentinel_alert_rule_template Name. |

All the parameter sets needs be provided for a valid query:
- `resource_group` , `workspace_name` and `alert_rule_template_id`
## Properties

| Name                           | Description                                                                      |
   |--------------------------------|----------------------------------------------------------------------------------|
| name                           | Name of the Azure resource to test.                                       |
| id                             | The sentinel_alert_rule_template type.                                                 |
| properties                     | The Properties of the Resource.                                | 
| type | Azure resource type. |
| kind | The alert rule kind. |
| properties.severity | The severity for alerts created by this alert rule. |
| properties.status| The alert rule template status. |
| properties.triggerThreshold | The threshold triggers this alert rule.  |
| properties.displayName| The display name for alert rule template..  |
| properties.triggerOperator | The operation against the threshold that triggers alert rule.  |
| properties.queryPeriod | The period (in ISO 8601 duration format) that this alert rule looks at. |
| properties.queryFrequency | The frequency (in ISO 8601 duration format) for this alert rule to run. |
## Examples

### Test if properties matches

 ```ruby
     describe azure_sentinel_alert_rule_template(resource_group: resource_group, workspace_name: workspace_name, alert_rule_template_id: alert_rule_template_id) do
          its('name') { should eq '968358d6-6af8-49bb-aaa4-187b3067fb95' }
          its('type') { should eq 'Microsoft.SecurityInsights/AlertRuleTemplates' }
          its('kind') { should eq 'Scheduled' }
          its('properties.triggerThreshold') { should eq 0 }
          its('properties.status') { should eq 'Available' }
          its('properties.displayName') { should eq 'Exchange SSRF Autodiscover ProxyShell - Detection' }
          its('properties.triggerOperator') { should eq 'GreaterThan' }
          its('properties.queryPeriod') { should eq 'PT12H' }
          its('properties.queryFrequency') { should eq 'PT12H' }
          its('properties.severity') { should eq 'High' }
     end
 ```


### Test that a sentinel_alert_rule_template exists

   ```ruby
   describe azure_sentinel_alert_rule_template(resource_group: resource_group, workspace_name: workspace_name, alert_rule_template_id: alert_rule_template_id) do
     it { should exist }
   end
   ```

### Test that a sentinel_alert_rule_template does not exist

   ```ruby
   describe azure_sentinel_alert_rule_template(resource_group: 'fake', workspace_name: workspace_name, alert_rule_template_id: alert_rule_template_id) do
     it { should_not exist }
   end
   ```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.