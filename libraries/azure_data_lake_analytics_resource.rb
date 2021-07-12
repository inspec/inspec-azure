require 'azure_generic_resource'

class AzureDataLakeAnalyticsResource < AzureGenericResource
  name 'azure_data_lake_analytics_resource'
  desc 'Verifies settings for an StorageLinkedService'
  example <<-EXAMPLE
    describe azure_data_lake_analytics_resource(resource_group: 'example', name: 'vm-name') do
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
    opts[:resource_provider] = specific_resource_constraint('Microsoft.DataLakeAnalytics/accounts/{accountName}', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureDataLakeAnalyticsResource)
  end

  def provisioning_state
    properties.provisioningState if exists?
  end

end
