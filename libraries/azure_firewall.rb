require 'azure_generic_resource'

class AzureFirewall < AzureGenericResource
  name 'azure_firewall'
  desc 'Verifies settings for an Azure Firewall'
  example <<-EXAMPLE
    describe azure_firewall(resource_group: 'rg-1', name: 'af-1') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/azureFirewalls', opts)
    opts[:resource_identifiers] = %i(azure_firewall_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureFirewall)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermFirewall < AzureFirewall
  name 'azurerm_firewall'
  desc 'Verifies settings for an Azure Firewall'
  example <<-EXAMPLE
    describe azurerm_firewall(resource_group: 'rg-1', azure_firewall_name: 'af-1') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureFirewall.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2019-05-01'
    super
  end
end
