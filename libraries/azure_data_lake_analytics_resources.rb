require 'azure_generic_resource'

class AzureDataLakeAnalyticsResources < AzureGenericResources
  name 'azure_data_lake_analytics_resources'
  desc 'Verifies settings for an StorageLinkedService'
  example <<-EXAMPLE
    describe azure_data_lake_analytics_resources(resource_group: 'example', name: 'vm-name') do
      it { should have_monitoring_agent_installed }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format for the resource:
    #   GET GET https://management.azure.com/subscriptions/{subscriptionId}/
    # resourceGroups/{resourceGroupName}/providers/Microsoft.DataLakeAnalytics/
    # accounts/{accountName}?api-version=2016-11-01
    #
    # The dynamic part that has to be created in this resource:
    #   Microsoft.DataLakeAnalytics/accounts/{accountName}?api-version=2016-11-01
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
    #       Microsoft.DataLakeAnalytics/accounts/{accountName}
    #   - api_version => Optional parameter. The latest version will be used unless provided. api-version
    #
    #   **`resource_group` and (resource) `name` or `resource_id`  will be validated in the backend appropriately.
    #     We don't have to do anything here.
    #
    # Following resource parameters have to be defined here.
    #   - resource_provider => Microsoft.DataLakeAnalytics/accounts/{accountName}
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #
    opts[:resource_provider] = specific_resource_constraint('Microsoft.DataLakeAnalytics/accounts', opts)
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
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
    AzureDataLakeAnalyticsResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureDataLakeAnalyticsResource)
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
