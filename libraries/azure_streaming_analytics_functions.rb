require 'azure_generic_resources'

class AzureStreamingAnalyticsFunctions< AzureGenericResources
  name 'azure_streaming_analytics_functions'
  desc 'Verifies settings for an Azure Function Streaming Analytics resource'
  example <<-EXAMPLE
    describe azure_streaming_analytics_functions(resource_group: 'rg-1', name: "test-job") do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.StreamAnalytics/streamingjobs', opts)
    opts[:required_parameters] = %i(job_name)
    opts[:resource_path] = [opts[:job_name], 'functions'].join('/')

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    return if failed_resource?
    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
    table_schema = [
      { column: :names, field: :name },
      { column: :ids, field: :id },
      { column: :properties, field: :properties },
      { column: :types, field: :type },
    ]
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureStreamingAnalyticsFunctions)
  end
end
