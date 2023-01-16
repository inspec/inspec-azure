require "azure_generic_resource"

class AzureDdosProtectionResource < AzureGenericResource
  name "azure_ddos_protection_resource"
  desc "Verifies settings for Azure DDoS Protection Standard "
  example <<-EXAMPLE
    describe azure_ddos_protection_resource(resource_group: 'example', name: 'vm-name') do
      it { should exit }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/
    # providers/Microsoft.Network/ddosProtectionPlans/{ddosProtectionPlanName}?api-version=2020-11-01
    #
    # The dynamic part that has to be created in this resource:
    #   Microsoft.Network/ddosProtectionPlans/{ddosProtectionPlanName}?api-version=2019-12-01
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #
    # User supplied parameters:
    #   - resource_group => Required parameter unless `resource_id` is provided. {resourceGroupName}
    #   - name => Required parameter unless `resource_id` is provided. Virtual machine name. {vmName}
    #   - resource_id => Optional parameter. If exists, `resource_group` and `name` must not be provided.
    #     In the following format:
    #       /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #       Microsoft.Network/ddosProtectionPlans/{ddosProtectionPlanName}
    #   - api_version => Optional parameter. The latest version will be used unless provided. api-version
    #
    #   **`resource_group` and (resource) `name` or `resource_id`  will be validated in the backend appropriately.
    #     We don't have to do anything here.
    #
    # Following resource parameters have to be defined here.
    #   - resource_provider => Microsoft.Network/virtualNetworks
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #
    opts[:resource_provider] = specific_resource_constraint("Microsoft.Network/ddosProtectionPlans", opts)
    opts[:required_parameters] = %i(name)
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureDdosProtectionResource)
  end

  # Resource specific methods can be created.
  # `return unless exists?` is necessary to prevent any unforeseen Ruby error.
  # Following methods are created to provide the same functionality with the current resource pack >>>>
  # @see https://github.com/inspec/inspec-azure

  def provisioning_state
    properties.provisioningState if exists?
  end

  def virtual_networks
    properties.virtualNetworks if exists?
  end

  def resource_guid
    properties.resourceGuid if exists?
  end
end
