require "azure_generic_resources"

class AzureDdosProtectionResources < AzureGenericResources
  name "azure_ddos_protection_resources"
  desc "Verifies settings for Azure DDoS Protection Standard "
  example <<-EXAMPLE
    azure_ddos_protection_resources(resource_group: 'rg') do
      it{ should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format listing the all resources for a given subscription and resource group:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/providers/
    # Microsoft.Network/ddosProtectionPlans?api-version=2020-11-01

    opts[:resource_provider] = specific_resource_constraint("Microsoft.Network/ddosProtectionPlans", opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of superclass methods or API calls.
    return if failed_resource?
    table_schema = [
      { column: :names, field: :name },
      { column: :types, field: :type },
      { column: :ids, field: :id },
      { column: :provisioning_states, field: :provisioningState },
      { column: :locations, field: :location },
      { column: :resource_guids, field: :resource_guid },
      { column: :virtual_networks, field: :virtual_networks },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureDdosProtectionResources)
  end

  private

  def populate_table
    return [] if @resources.empty?

    @resources.each do |resource|
      @table << {
        id: resource[:id],
        name: resource[:name],
        type: resource[:type],
        provisioningState: resource[:properties][:provisioningState],
        location: resource[:location],
        resource_guid: resource[:properties][:resourceGuid],
        virtual_networks: resource[:properties][:virtualNetworks],
      }
    end
  end
end
