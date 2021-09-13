---
title: About the azure_migrate_assessments Resource
platform: azure
---

# azure_migrate_assessments

Use the `azure_migrate_assessments` InSpec audit resource to test the properties related to all Azure Migrate Assessments within a project.

## Azure REST API version, Endpoint, and HTTP Client Parameters

This resource interacts with API versions supported by the resource provider. The `api_version` is defined as a resource parameter.
If not provided, the latest version is used. For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint and default values for the HTTP client is used. For more information, refer to the resource pack [README](../../README.md).

## Availability

### Installation

This resource is available in the [InSpec Azure resource pack](https://github.com/inspec/inspec-azure). For an example, `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_migrate_assessments` resource block returns all Azure Migrate Assessments within a project.

```ruby
describe azure_migrate_assessments(resource_group: 'MIGRATED_VMS', project_name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT') do
  #...
end
```

## Parameters
| Name           | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| resource_group | Azure resource group that the targeted resource resides in. `MyResourceGroup`    |
| project_name   | Azure Migrate Assessment Project.                                                |

The parameter set should be provided for a valid query:
- `resource_group` and `project_name`

## Properties

|Property                        | Description                                                            | Filter Criteria<superscript>*</superscript> |
|--------------------------------|------------------------------------------------------------------------|------------------|
| ids                            | Path reference to the assessments.                                     | `id`             |
| names                          | Unique names for all assessments.                                      | `name`           |
| types                          | Type of the objects.                                                   | `type`           |
| eTags                          | A list of eTags for all the assessments.                               | `eTag`           |
| properties                     | A list of Properties for all the assessments.                          | `properties`     |
| azureDiskTypes                 | Storage type selected for the disk of all the assessments.             | `azureDiskType`  |
| azureHybridUseBenefits         | AHUB discount on windows virtual machines of all the assessments.      | `azureHybridUseBenefit`|
| azureLocations                 | Target Azure locations for which the machines should be assessed.      | `azureLocation`  |
| azureOfferCodes                | Offer codes according to which cost estimation is done.                | `azureOfferCode` |
| azurePricingTiers              | Pricing tiers for Size evaluation.                                     | `azurePricingTier`|
| azureStorageRedundancies       | Storage Redundancy types offered by Azure.                             | `azureStorageRedundancy`|
| azureVmFamilies                | List of azure VM families.                                             | `azureVmFamilies`|
| confidenceRatingInPercentages  | Confidence rating percentages for assessment.                          | `confidenceRatingInPercentage`|
| createdTimestamps              | Time when this project is created.                                     | `createdTimestamp` |
| currencies                     | Currencies to report prices in.                                        | `currency`       |
| discountPercentages            | Custom discount percentages to be applied on final costs.              | `discountPercentage`|
| eaSubscriptionIds              | Enterprise agreement subscription arm ids.                             | `eaSubscriptionId`|
| monthlyBandwidthCosts          | Monthly network cost estimates for the machines.                       | `monthlyBandwidthCost`|
| monthlyComputeCosts            | Monthly compute cost estimates for the machines.                       | `monthlyComputeCost`|
| monthlyPremiumStorageCosts     | Monthly premium storage cost estimates for the machines.               | `monthlyPremiumStorageCost`|
| monthlyStandardSSDStorageCosts | Monthly standard SSD storage cost estimates for the machines.          | `monthlyStandardSSDStorageCost`|
| monthlyStorageCosts            | Monthly storage cost estimates for the machines.                       | `monthlyStorageCost` |
| numberOfMachines               | Number of assessed machines part of the assessments.                   | `numberOfMachines` |
| percentiles                    | Percentiles of performance data used to recommend Azure size.          | `percentile`     |
| perfDataEndTimes               | End times to consider performance data for assessments.                | `perfDataEndTime`|
| perfDataStartTimes             | Start times to consider performance data for assessments.              | `perfDataStartTime` |
| pricesTimestamps               | Times when the Azure Prices are queried.                               | `pricesTimestamp`|
| reservedInstances              | Azure reserved instances.                                              | `reservedInstance`|
| scalingFactors                 | Scaling factors used over utilization data to add a performance buffer for new machines to be created in Azure.| `scalingFactor` |
| sizingCriterions               | Assessment sizing criterions.                                          | `sizingCriterion`|
| stages                         | User configurable setting that describes the status of the assessments.| `stage`          |
| statuses                       | Whether the assessments have been created and is valid.                | `status`         |
| timeRanges                     | Time ranges of performance data used to recommend a size.              | `timeRange`      |
| updatedTimestamps              | Times when the project is last updated.                                | `updatedTimestamp`|
| vmUptimes                      | Specify the durations for which the VMs are up in the on-premises environment.| `vmUptime`|

Refer to the [Azure Migrate assements documentation](https://docs.microsoft.com/en-us/rest/api/migrate/assessment/assessments/list-by-project) for additional information. 
<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through Migrate Assessments by their names

```ruby
azure_migrate_assessments(resource_group: 'MIGRATED_VMS', project_name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT').names.each do |name|
  describe azure_container_group(resource_group: 'MIGRATED_VMS', project_name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT', group_name: 'ZONEA_MACHINES_GROUP', name: name) do
    it { should exist }
  end
end
```

### Test to ensure Migrate assessments exist with local redundancy

```ruby
describe azure_migrate_assessments(resource_group: 'MIGRATED_VMS', project_name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT').where(azureStorageRedundancy: 'LOCALLYREDUNDANT') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Migrate Assessments are present in the project and in the resource group
describe azure_migrate_assessments(resource_group: 'MIGRATED_VMS', project_name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT') do
  it { should_not exist }
end

# Should exist if the filter returns at least one Migrate Assessment in the project and in the resource group
describe azure_migrate_assessments(resource_group: 'MIGRATED_VMS', project_name: 'ZONEA_MIGRATE_ASSESSMENT_PROJECT') do
  it { should exist }
end
```

## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be set up with a `contributor` role on the subscription you wish to test.
