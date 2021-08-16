---
title: About the azure_migrate_project_solutions Resource
platform: azure
---

# azure_migrate_project_solutions

Use the `azure_migrate_project_solutions` InSpec audit resource to test properties related to all Azure Migrate Project Solutions within a project.

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

An `azure_migrate_project_solutions` resource block returns all Azure Migrate Project Solutions within a project.

```ruby
describe azure_migrate_project_solutions(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project') do
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
| ids                            | Path reference to the Project Solutions.                                     | `id`             |
| names                          | Unique names for all Project Solutions.                                      | `name`           |
| types                          | Type of the objects.                                                   | `type`           |
| eTags                          | A list of eTags for all the Project Solutions.                               | `eTag`           |
| properties                     | A list of Properties for all the Project Solutions.                          | `properties`     |
| azureDiskTypes                 | Storage type selected for the disk of all the assessments.             | `azureDiskType`  |
| azureHybridUseBenefits         | AHUB discount on windows virtual machines of all the assessments.      | `azureHybridUseBenefit`|
| azureLocations                 | Target Azure locations for which the machines should be assessed.      | `azureLocation` |
| azureOfferCodes                | Offer codes according to which cost estimation is done.                | `azureOfferCode` |
| azurePricingTiers              | Pricing tiers for Size evaluation.                                     | `azurePricingTier`|
| azureStorageRedundancies       | Storage Redundancy types offered by Azure.                             | `azureStorageRedundancy`|
| azureVmFamilies                | List of azure VM families.                                             | `azureVmFamilies`|
| confidenceRatingInPercentages  | Confidence rating percentages for assessment.                          | `confidenceRatingInPercentage`|
| createdTimestamps              | Time when this project was created.                                    | `createdTimestamp` |
| currencies                     | Currencies to report prices in.                                        | `currency`       |
| discountPercentages            | Custom discount percentages to be applied on final costs.              | `discountPercentage`|
| eaSubscriptionIds              | Enterprise agreement subscription arm ids.                             | `eaSubscriptionId`|
| monthlyBandwidthCosts          | Monthly network cost estimates for the machines.                       | `monthlyBandwidthCost`|
| monthlyComputeCosts            | Monthly compute cost estimates for the machines.                       | `monthlyComputeCost`|
| monthlyPremiumStorageCosts     | Monthly premium storage cost estimates for the machines.               | `monthlyPremiumStorageCost`|
| monthlyStandardSSDStorageCosts | Monthly standard SSD storage cost estimates for the machines.          | `monthlyStandardSSDStorageCost`|
| monthlyStorageCosts            | Monthly storage cost estimates for the machines.                       | `monthlyStorageCost` |
| numberOfMachines               | Number of assessed machines part of the assessments.                   | `numberOfMachines` |
| percentiles                    | Percentiles of performance data used to recommend Azure size.          | `percentile` |
| perfDataEndTimes               | End times to consider performance data for assessments.                | `perfDataEndTime` |
| perfDataStartTimes             | Start times to consider performance data for assessments.              | `perfDataStartTime` |
| pricesTimestamps               | Times when the Azure Prices were queried.                              | `pricesTimestamp` |
| reservedInstances              | Azure reserved instances.                                              | `reservedInstance`
| scalingFactors                 | Scaling factors used over utilization data to add a performance buffer for new machines to be created in Azure.| `scalingFactor` |
| sizingCriterions               | Assessment sizing criterions.                                          | `sizingCriterion` |
| stages                         | User configurable setting that describes the status of the assessments.| `stage`           |
| statuses                       | Whether the assessments has been created and is valid.                 | `status`          |
| timeRanges                     | Time ranges of performance data used to recommend a size.              | `timeRange`       |
| updatedTimestamps              | Times when the project was last updated.                               | `updatedTimestamp`|
| vmUptimes                      | Specify the durations for which the VMs are up in the on-premises environment.| `vmUptime` |


<superscript>*</superscript> For information on how to use filter criteria on plural resources refer to [FilterTable usage](https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md).

## Examples

### Loop through Migrate Project Solutions by their names.

```ruby
azure_migrate_project_solutions(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project').names.each do |name|
  describe azure_container_group(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project', group_name: 'zoneA_machines_group', name: name) do
    it { should exist }
  end
end
```
### Test that there are Migrate Project Solutions with local redundancy.

```ruby
describe azure_migrate_project_solutions(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project').where(azureStorageRedundancy: 'LocallyRedundant') do
  it { should exist }
end
```

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://www.inspec.io/docs/reference/matchers/).

### exists

```ruby
# Should not exist if no Migrate Project Solutions are present in the project and in the resource group
describe azure_migrate_project_solutions(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project') do
  it { should_not exist }
end
# Should exist if the filter returns at least one Migrate Project Solutions in the project and in the resource group
describe azure_migrate_project_solutions(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_assessment_project') do
  it { should exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.