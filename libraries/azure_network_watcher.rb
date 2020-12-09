require 'azure_generic_resource'

class AzureNetworkWatcher < AzureGenericResource
  name 'azure_network_watcher'
  desc 'Verifies settings for Network Watchers'
  example <<-EXAMPLE
    describe azure_network_watcher(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  # This is for backward compatibility.
  attr_accessor :nsg

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/networkWatchers', opts)
    opts[:allowed_parameters] = %i(flow_logs_api_version nsg_resource_id nsg_resource_group nsg_name)
    opts[:flow_logs_api_version] ||= 'latest'

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureNetworkWatcher)
  end

  def provisioning_state
    return unless exists?
    properties&.provisioningState
  end

  def flow_logs
    return unless exists?
    # This is for backward compatibility. !!! NOT RECOMMENDED !!!
    # nsg is the name of the network security group.
    # It can be defined on the instance of this resource.
    #       nw = azure_network_watcher(resource_group: resource_group, name: nw_name)
    #       nw.nsg = nsg
    # It must be within the same resource group with the network watcher.
    if nsg
      target_resource_id = validate_resource_uri(
        {
          resource_uri:
              "/resourceGroups/#{@opts[:resource_group]}/providers/Microsoft.Network/networkSecurityGroups/#{nsg}",
            add_subscription_id: true,
        },
      )
    elsif @opts[:nsg_resource_group] && @opts[:nsg_name]
      # network security group can be provided with its resource group and name.
      target_resource_id = validate_resource_uri(
        {
          resource_uri:
              "/resourceGroups/#{@opts[:nsg_resource_group]}/providers/Microsoft.Network/networkSecurityGroups/"\
              "#{@opts[:nsg_name]}",
            add_subscription_id: true,
        },
      )
    elsif @opts[:nsg_resource_id]
      # network security group can be provided with its resource id.
      target_resource_id = @opts[:nsg_resource_id]
    else
      raise ArgumentError,
            'The resource group (nsg_resource_group) and the name (nsg_name) of the network security group or '\
            'the resource id (nsg_resource_id) must be provided at resource initiation.'
    end
    req_body_hash = {
      targetResourceId: target_resource_id,
    }
    additional_resource_properties(
      {
        property_name: 'flow_logs',
        property_endpoint: "#{id}/queryFlowLogStatus",
        api_version: @opts[:flow_logs_api_version],
        method: 'post',
        req_body: JSON.generate(req_body_hash),
        headers: { 'Content-Type' => 'application/json' },
      },
    )
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermNetworkWatcher < AzureNetworkWatcher
  name 'azurerm_network_watcher'
  desc 'Verifies settings for Network Watchers'
  example <<-EXAMPLE
    describe azurerm_network_watcher(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureNetworkWatcher.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2018-02-01'
    opts[:flow_logs_api_version] ||= '2019-04-01'
    super
  end
end
