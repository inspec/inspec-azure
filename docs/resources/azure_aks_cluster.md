---
title: About the azure_aks_cluster Resource
platform: azure
---

# azure_aks_cluster

Use the `azure_aks_cluster` InSpec audit resource to test properties of an Azure AKS Cluster.

## Azure REST API version, endpoint and http client parameters

This resource interacts with api versions supported by the resource provider.
The `api_version` can be defined as a resource parameter.
If not provided, the latest version will be used.
For more information, refer to [`azure_generic_resource`](azure_generic_resource.md).

Unless defined, `azure_cloud` global endpoint, and default values for the http client will be used .
For more information, refer to the resource pack [README](../../README.md). 

## Availability

### Installation

This resource is available in the `inspec-azure` [resource pack](https://github.com/inspec/inspec-azure). 
For an example `inspec.yml` file and how to set up your Azure credentials, refer to resource pack [README](../../README.md#Service-Principal).

## Syntax

An `azure_aks_cluster` resource block identifies an AKS Cluster by `name` and `resource_group`.
```ruby
describe azure_aks_cluster(resource_group: 'example', name: 'ClusterName') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `MyResourceGroup`     |
| name                           | Name of the AKS cluster to test. `ClusterName`                                      |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.ContainerService/managedClusters/{ClusterName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`

## Properties

| Property          | Description |
|-------------------|-------------|
| identity          | The identity of the managed cluster, if configured. It is a [managed cluster identity object](https://docs.microsoft.com/en-us/rest/api/aks/managedclusters/get#managedclusteridentity). |
| sku               | The SKU (pricing tier) of the resource. |

For parameters applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#parameters).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/aks/managedclusters/get#managedcluster) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test that an Example Resource Group has the Specified AKS Cluster
```ruby
describe azure_aks_cluster(resource_group: 'example', name: 'ClusterName') do
  it { should exist }
end
```
### Test that a Specified AKS Cluster was Successfully Provisioned
```ruby
describe azure_aks_cluster(resource_group: 'example', name: 'ClusterName') do
  its('properties.provisioningState') { should cmp 'Succeeded' }
end
```
### Test that a Specified AKS Cluster the Correct Number of Nodes in Pool
```ruby
describe azure_aks_cluster(resource_group: 'example', name: 'ClusterName') do
  its('properties.agentPoolProfiles.first.count') { should cmp 5 }
end
```
## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### exists
```ruby
# If we expect 'ClusterName' to always exist
describe azure_aks_cluster(resource_group: 'example', name: 'ClusterName') do
  it { should exist }
end

# If we expect 'ClusterName' to never exist
describe azure_aks_cluster(resource_group: 'example', name: 'ClusterName') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
