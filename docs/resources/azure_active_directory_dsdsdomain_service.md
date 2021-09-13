---
title: About the azure_sentinel_alert_rule Resource
platform: azure
---

# azure_sentinel_alert_rule

Use the `azure_sentinel_alert_rule` InSpec audit resource to test properties of an Azure azure_sentinel_alert_rule.

## Azure REST API version, endpoint, and HTTP client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the HTTP client will be used.
For more information, refer to the resource pack [README](../../README.md).
For api related info : [`Azure azure_sentinel_alert_rule Docs`](https://docs.microsoft.com/en-us/rest/api/securityinsights/alert-rule-templates/get).


## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure).
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

`resource_group` and `rule_id`, `workspace_name` must be given as parameters.

    ```ruby
    describe azure_sentinel_alert_rule(resource_group: resource_group, workspace_name: workspace_name, rule_id: rule_id) do
      
    end
    ```

## Parameters

| Name                           | Description                                                                       |
    |--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| workspace_name                           | Name for the workspace_name that you want to create your azure_sentinel_alert_rule in..                                                                 |
| rule_id                 | Alert rule ID. |

All the parameter sets needs be provided for a valid query:
- `resource_group` , `workspace_name` and `rule_id`
## Properties

| Name                           | Description                                                                      |
    |--------------------------------|----------------------------------------------------------------------------------|
| name                           | Name of the Azure resource to test.                                       |
| id                             | The azure_sentinel_alert_rule type.                                                 |
| properties                     | The Properties of the Resource.                                | 
| type | Azure resource type. |
| kind | The alert rule kind. |
| properties.severity | The severity for alerts created by this alert rule.  |
| properties.displayName| Display name for alerts created by this alert rule.  |
| properties.enabled | The list of flags which Determines whether this alert rule is enabled or disabled.  |
| properties.alertRuleTemplateName | The Name of the alert rule template used to create this rule. |
## Examples

### Test if properties matches

  ```ruby
      describe azure_sentinel_alert_rule(resource_group: resource_group, workspace_name: workspace_name, rule_id: rule_id) do
          its('name') { should eq 'BuiltInFusion' }
          its('type') { should eq 'Microsoft.SecurityInsights/alertRules' }
          its('kind') { should eq 'Fusion' }
          its('properties.displayName') { should eq 'Advanced Multistage Attack Detection' }
          its('properties.enabled') { should eq true }
          its('properties.alertRuleTemplateName') { should eq 'f71aba3d-28fb-450b-b192-4e76a83015c8' }
          its('properties.severity') { should eq 'High' }
      end
  ```


### Test that a azure_sentinel_alert_rule exists

    ```ruby
    describe azure_sentinel_alert_rule(resource_group: resource_group, workspace_name: workspace_name, rule_id: rule_id) do
      it { should exist }
    end
    ```

### Test that a azure_sentinel_alert_rule does not exist

    ```ruby
    describe azure_sentinel_alert_rule(resource_group: 'fake', workspace_name: workspace_name, rule_id: rule_id) do
      it { should_not exist }
    end
    ```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.