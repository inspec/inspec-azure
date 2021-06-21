---
title: About the azure_policy_exemptions Resource
platform: azure
---

# azure_policy_exemptions

Use the `azure_policy_exemptions` InSpec audit resource to test properties related to all Azure Policy Exemptions for the subscription.

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

An `azure_policy_exemptions` resource block returns all Azure Policy Exemptions within a Subscription.
```ruby
describe azure_policy_exemptions do
  #...
end
```

## Parameters

## Properties

|Property            | Description                                        | Filter Criteria<superscript>*</superscript> |
|--------------------|----------------------------------------------------|-----------------|
| ids                | A list of the unique resource ids.                 | `id`            |
| names              | A list of names for all the Resources.             | `name`          |
| types              | A list of types for all the resources.             | `type`          |
| properties         | A list of Properties all the resources.            | `properties`    |
| system_data        | A list of System Data for all the resources.       | `system_data`   |
| policy_assignment_ids| A list of Policy Assignment IDs.                 | `policy_assignment_id` |
| policy_definition_reference_ids| A list of Policy Definition Reference Ids.| `policy_definition_reference_ids` | 
| exemption_categories| A list of categories of Exemptions.               | `exemption_category` |
| display_names      | A list of display names of the Exemptions.         | `display_name`  |
| descriptions       | A list of descriptions of the Exemptions. .        | `description`   |
| metadata           | A list of metadata info of the Exemptions.         | `metadata`      |
| created_by         | A list of creators of the exemptions.              | `created_by`    |
| created_by_types   | A list of type of creators of the exemptions.      | `created_by_type` |
| created_at         | A list of created_at timestamps of the exemptions  | `created_at`|
| last_modified_by   | A list of last modifiers of the exemptions.        | `last_modified_by` |
| last_modified_by_types| A list of type of the modifiers of the exemptions.| `last_modified_by_type` |
| last_modified_at   | A list of modified_at timestamps of the exemptions | `last_modified_at` |


<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through Policy Exemptions by Their Names
```ruby
azure_policy_exemptions.names.each do |name|
  describe azure_policy_exemption(name: name) do
    it { should exist }
  end
end  
```     
### Test that There are Policy Exemptions that are of waiver exemption category 
```ruby
describe azure_policy_exemptions.where(exemption_category: 'Waiver') do
  it { should exist }
end
```    

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists
```ruby
# Should not exist if no policy exemptions are present in the subscription
describe azure_policy_exemptions do
  it { should_not exist }
end

# Should exist if the filter returns at least one policy exemption in the subscription
describe azure_policy_exemptions do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.