require 'azure_generic_resources'

class AzureNetworkSecurityGroups < AzureGenericResources
  name 'azure_network_security_groups'
  desc 'Verifies settings for Network Security Groups'
  example <<-EXAMPLE
    azure_network_security_groups(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format listing the all resources for a given subscription:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/providers/
    #   Microsoft.Network/networkSecurityGroups?api-version=2020-05-01
    #
    # or in a resource group only
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #   Microsoft.Network/networkSecurityGroups?api-version=2020-05-01
    #
    # The dynamic part that has to be created for this resource:
    #   Microsoft.Network/networkSecurityGroups?api-version=2020-05-01
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #
    # For parameters applicable to all resources, see project's README.
    #
    # User supplied parameters:
    #   - resource_group => Optional parameter.
    #   - api_version => Optional parameter. The latest version will be used unless provided.
    #
    #   **`resource_group`  will be used in the backend appropriately.
    #     We don't have to do anything here.
    #
    # Following resource parameters have to be defined/created here.
    #   resource_provider => Microsoft.Network/networkSecurityGroups
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #
    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/networkSecurityGroups', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureNetworkSecurityGroups)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermNetworkSecurityGroups < AzureNetworkSecurityGroups
  name 'azurerm_network_security_groups'
  desc 'Verifies settings for Network Security Groups'
  example <<-EXAMPLE
    azurerm_network_security_groups(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureNetworkSecurityGroups.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2018-02-01'
    super
  end
end
