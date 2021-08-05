require 'azure_generic_resources'

class AzureDdosProtectionResources < AzureGenericResources
  name 'azure_ddos_protection_resources'
  desc 'Verifies settings for Azure DDoS Protection Standard '
  example <<-EXAMPLE
    azure_ddos_protection_resources(resource_group: 'example') do
      it{ should exists }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format listing the all resources for a given subscription:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/providers/
    # Microsoft.Network/ddosProtectionPlans?api-version=2020-11-01

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/ddosProtectionPlans', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of superclass methods or API calls.
    return if failed_resource?
    table_schema = [
      { column: :names, field: :name },
      { column: :types, field: :type },
      { column: :ids, field: :id },
      { column: :tags, field: :tags },
      { column: :provisioning_states, field: :provisioningState },
      { column: :locations, field: :location },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureDdosProtectionResources)
  end

  private

  # Populate the @table with the resource attributes.
  # @table has been declared in the super class as an empty array.
  # Each item in the @table
  #   - should be a Hash object
  #   - should have the exact key names defined in the @table_schema as `field`.
  def populate_table
    # If @resources empty than @table should stay as an empty array as declared in superclass.
    # This will ensure constructing resource and passing `should_not exist` test.
    return [] if @resources.empty?

    @resources.each do |resource|
      @table << {
        id: resource[:id],
        name: resource[:name],
        type: resource[:type],
        tags: resource[:tags],
        provisioningState: resource[:properties][:provisioningState],
        location: resource[:location],
      }
    end
  end
end
