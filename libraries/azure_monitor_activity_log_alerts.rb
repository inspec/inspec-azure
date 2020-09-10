require 'azure_generic_resources'

class AzureMonitorActivityLogAlerts < AzureGenericResources
  name 'azure_monitor_activity_log_alerts'
  desc 'Verifies settings for Azure Monitor Activity Log Alerts'
  example <<-EXAMPLE
    describe azure_monitor_activity_log_alerts do
      its('names') { should include('example-log-alert') }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Insights/activityLogAlerts', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
    table_schema = [
      { column: :names, field: :name },
      { column: :ids, field: :id },
      { column: :tags, field: :tags },
      { column: :location, field: :location },
      { column: :resource_group, field: :resource_group },
      { column: :operations, field: :operations },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureMonitorActivityLogAlerts)
  end

  private

  def populate_table
    # If @resources empty than @table should stay as an empty array as declared in superclass.
    # This will ensure constructing resource and passing `should_not exist` test.
    return [] if @resources.empty?
    @resources.each do |resource|
      operations = resource[:properties].dig(:condition, :allOf)
          &.select { |alert| alert[:field] == 'operationName' }&.collect { |al| al[:equals] }
      resource_group, _provider, _r_type = Helpers.res_group_provider_type_from_uri(resource[:id])
      @table << {
        id: resource[:id],
        name: resource[:name],
        tags: resource[:tags],
        location: resource[:location],
        operations: operations,
        resource_group: resource_group,
      }
    end
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermMonitorActivityLogAlerts < AzureMonitorActivityLogAlerts
  name 'azurerm_monitor_activity_log_alerts'
  desc 'Verifies settings for Azure Monitor Activity Log Alerts'
  example <<-EXAMPLE
    describe azurerm_monitor_activity_log_alerts do
      its('names') { should include('example-log-alert') }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureMonitorActivityLogAlerts.name)
    super
  end
end
