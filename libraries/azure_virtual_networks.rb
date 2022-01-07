require 'azure_generic_resources'

class AzureVirtualNetworks < AzureGenericResources
  name 'azure_virtual_networks'
  desc 'Verifies settings for Azure Virtual Networks'
  example <<-EXAMPLE
    azure_virtual_networks(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format listing the all resources for a given subscription:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/providers/
    #   Microsoft.Network/virtualNetworks?api-version=2020-05-01
    #
    # or in a resource group only
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #   Microsoft.Network/virtualNetworks?api-version=2020-05-01
    #
    # The dynamic part that has to be created for this resource:
    #   Microsoft.Network/virtualNetworks?api-version=2020-05-01
    #
    # User supplied parameters:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #   - {resourceGroupName} => Optional parameter. It should be provided by the user. (`resource_group`)
    #   - api-version => Optional parameter. The latest version will be used by the backend if not provided. (`api_version`)
    #
    #   **`resource_group` will be added into the URL appropriately in the backend.
    #     We don't have to do anything here.
    #
    # Following resource parameters have to be defined/created here.
    #   resource_provider => Microsoft.Network/virtualNetworks

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/virtualNetworks', opts)

    # Establish a connection with Azure REST API.
    # Initiate instance variables: @table and @resources.
    #   - @table => It will be used for populating FilterTable in the `AzureGenericResources.populate_filter_table` class method.
    #   - @resources => It will be used for populating the @table in the `populate_table` instance method.
    #
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    #   - column: It is defined as an instance method, callable on the resource, and present `field` values in a list.
    #   - field: It has to be identical with the `key` names in @table items that will be presented in the FilterTable.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
    table_schema = [
      { column: :names, field: :name },
      { column: :etags, field: :etag },
      { column: :ids, field: :id },
      { column: :tags, field: :tags },
      { column: :locations, field: :location },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureVirtualNetworks)
  end
end
