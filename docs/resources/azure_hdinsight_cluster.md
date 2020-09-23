---
title: About the azure_hdinsight_cluster Resource
platform: azure
---

# azure_hdinsight_cluster

Use the `azure_hdinsight_cluster` InSpec audit resource to test properties of an Azure HDInsight Cluster.

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

An `azure_hdinsight_cluster` resource block identifies a HDInsight Cluster by `name` and `resource_group` or the `resource_id`.
```ruby
describe azure_hdinsight_cluster(resource_group: 'example', name: 'ClusterName') do
  it { should exist }
end
```
```ruby
describe azure_hdinsight_cluster(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HDInsight/clusters/{clusterName}') do
  it { should exist }
end
```
## Parameters

| Name                           | Description                                                                       |
|--------------------------------|-----------------------------------------------------------------------------------|
| resource_group                 | Azure resource group that the targeted resource resides in. `resourceGroupName`   |
| name                           | The unique name of the cluster. `clusterName`                                     |
| resource_id                    | The unique resource ID. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HDInsight/clusters/{clusterName}` |

Either one of the parameter sets can be provided for a valid query:
- `resource_id`
- `resource_group` and `name`

## Properties

| Property                          | Description |
|-----------------------------------|-------------|
| properties.clusterVersion         | The version of the cluster. |

For properties applicable to all resources, such as `type`, `name`, `id`, `properties`, refer to [`azure_generic_resource`](azure_generic_resource.md#properties).

Also, refer to [Azure documentation](https://docs.microsoft.com/en-us/rest/api/hdinsight/clusters/get) for other properties available. 
Any attribute in the response may be accessed with the key names separated by dots (`.`).

## Examples

### Test that a Specified HDInsight Cluster is Successfully Provisioned
```ruby
describe azure_hdinsight_cluster(resource_group: 'example', name: 'ClusterName') do
  its('properties.provisioningState') { should cmp 'Succeeded' }
end
```
```ruby
describe azure_hdinsight_cluster(resource_id: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HDInsight/clusters/{clusterName}') do
  its('properties.provisioningState') { should cmp 'Succeeded' }
end
```
### Test the Version of a HDInsight Cluster
```ruby
describe azure_hdinsight_cluster(resource_group: 'example', name: 'ClusterName') do
  its('properties.clusterVersion') { should cmp  '4.0' }
end
```
See [integration tests](../../test/integration/verify/controls/azurerm_hdinsight_cluster.rb) for more examples.

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [Universal Matchers page](https://docs.chef.io/inspec/matchers/).

### exists
```ruby
# If we expect the resource to always exist
describe azure_hdinsight_cluster(resource_group: 'example', name: 'ClusterName') do
  it { should exist }
end

# If we expect the resource not to exist
describe azure_hdinsight_cluster(resource_group: 'example', name: 'ClusterName') do
  it { should_not exist }
end
```
## Azure Permissions

Your [Service Principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal) must be setup with a `contributor` role on the subscription you wish to test.
