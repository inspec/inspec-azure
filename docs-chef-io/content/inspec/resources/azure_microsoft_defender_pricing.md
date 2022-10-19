+++
title = "azure_microsoft_defender_pricing Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_microsoft_defender_pricing"
identifier = "inspec/resources/azure/azure_microsoft_defender_pricing Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_microsoft_defender_pricing` InSpec audit resource to test the properties of an Azure Microsoft Defender Pricing.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

```ruby
describe azure_microsoft_defender_pricing(name: 'DEFENDER_PRICING_NAME') do
  it { should exist }
end
```

## Parameters

`name`
: The name of the resource.

: **Example**: `VirtualMachines`

## Properties

`id`
: The id of the resource.

`name`
: The name of the resource.

`type`
: The type of the resource.

`properties.deprecated`
: Optional. True if the plan is deprecated. If there are replacing plans they will appear in replacedBy property

`properties.freeTrialRemainingTime`
: The duration left for the subscriptions free trial period - in ISO 8601 format (e.g. P3Y6M4DT12H30M5S).

`properties.pricingTier`
: The pricing tier value. Microsoft Defender for Cloud is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features.

`properties.replacedBy`
: Optional. List of plans that replace this plan. This property exists only if this plan is deprecated.

`properties.subPlan`
: The sub-plan selected for a Standard pricing configuration, when more than one sub-plan is available. Each sub-plan enables a set of security features. When not specified, full plan is applied.

## Examples

### Test if a name exists

```ruby
describe azure_microsoft_defender_pricing(name: 'VirtualNames') do
  it { should exist }
end
```

### Test if a name do not exists

```ruby
describe azure_microsoft_defender_pricing(name: 'Demo') do
  it { should_not exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exists

```ruby
describe azure_microsoft_defender_pricing(name: 'VirtualNames') do
  it { should exist }
end
```

## Azure Permissions

Graph resources require specific privileges granted to your service principal. Please refer to the [Microsoft Documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications#updating-an-application) for information on how to grant these permissions to your application.
