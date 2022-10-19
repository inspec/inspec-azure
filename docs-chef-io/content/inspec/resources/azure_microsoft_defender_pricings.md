+++
title = "azure_microsoft_defender_pricings Resource"
platform = "azure"
draft = false
gh_repo = "inspec-azure"

[menu.inspec]
title = "azure_microsoft_defender_pricings"
identifier = "inspec/resources/azure/azure_microsoft_defender_pricings Resource"
parent = "inspec/resources/azure"
+++

Use the `azure_microsoft_defender_pricings` InSpec audit resource to test the properties of some or all Azure Microsoft Defender Pricing.

## Azure REST API Version, Endpoint, and HTTP Client Parameters

{{% inspec_azure_common_parameters %}}

## Installation

{{% inspec_azure_install %}}

## Syntax

```ruby
describe azure_microsoft_defender_pricings do
  #...
end
```

## Parameters

No required parameters.

## Properties

`ids`
: The id of the resource.

: **Field**: `id`

`names`
: The name of the resource.

: **Field**: `name`

`types`
: The type of the resource.

: **Field**: `type`

`freeTrialRemainingTimes`
: The duration left for the subscriptions free trial period - in ISO 8601 format (e.g. P3Y6M4DT12H30M5S).

: **Field**: `properties.freeTrialRemainingTime`

`pricingTiers`
: The pricing tier value. Microsoft Defender for Cloud is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features.

: **Field**: `properties.pricingTier`

`subPlans`
: The sub-plan selected for a Standard pricing configuration, when more than one sub-plan is available. Each sub-plan enables a set of security features. When not specified, full plan is applied.

: **Field**: `properties.subPlan`

{{% inspec_filter_table %}}

## Examples

The following examples show how to use this InSpec audit resource.

### Test if a name exists

```ruby
describe azure_microsoft_defender_pricings do
  it { should exist }
end
```

### Test if a name do not exists

```ruby
describe azure_microsoft_defender_pricings do
  it { should_not exist }
end
```

## Matchers

{{% inspec_matchers_link %}}

### exist

The control passes if the filter returns at least one result. Use `should_not` if you expect zero matches.

```ruby
describe azure_microsoft_defender_pricings do
  it { should_not exist }
end
```

## Azure Permissions

Graph resources require specific privileges granted to your service principal. Please refer to the [Microsoft Documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications#updating-an-application) for information on how to grant these permissions to your application.
