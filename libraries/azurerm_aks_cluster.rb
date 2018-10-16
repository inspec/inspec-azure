# frozen_string_literal: true

require 'azurerm_resource'

class AzurermAksCluster < AzurermSingularResource
  name 'azurerm_aks_cluster'
  desc 'Verifies settings for AKS Clusters'
  example <<-EXAMPLE
    describe azurerm_aks_cluster(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  ATTRS = %i(
    name
    id
    etag
    type
    location
    tags
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, name: nil)
    resp = management.aks_cluster(resource_group, name)
    return if has_error?(resp)

    assign_fields(ATTRS, resp)

    @exists = true
  end

  def to_s
    "'#{name}' AKS Cluster"
  end

  def provisioning_state
    @properties['provisioningState']
  end

  def kubernetes_version
    @properties['kubernetesVersion']
  end

  def dns_prefix
    @properties['dnsPrefix']
  end

  def fqdn
    @properties['fqdn']
  end

  def pool_name
    @properties['agentPoolProfiles'][0]['name']
  end

  def pool_count
    @properties['agentPoolProfiles'][0]['count']
  end

  def pool_vm_size
    @properties['agentPoolProfiles'][0]['vmSize']
  end

  def pool_storage_profile
    @properties['agentPoolProfiles'][0]['storageProfile']
  end

  def pool_max_pods
    @properties['agentPoolProfiles'][0]['maxPods']
  end

  def pool_os_type
    @properties['agentPoolProfiles'][0]['osType']
  end
end
