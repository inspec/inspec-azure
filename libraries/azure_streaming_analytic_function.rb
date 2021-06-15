require 'azure_generic_resource'

class AzureStreamingAnalyticsFunction < AzureGenericResource
  name 'azure_streaming_analytics_function'
  desc 'Verifies settings for an Azure Function Streaming Analytics resource'
  example <<-EXAMPLE
    describe azure_streaming_analytics_function(resource_group: 'rg-1', function_name: "test", job_name: "test-job") do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.StreamAnalytics/streamingjobs', opts)
    opts[:required_parameters] = %i(job_name)
    opts[:resource_path] = [opts[:job_name], 'functions'].join('/')
    opts[:resource_identifiers] = %i(function_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureStreamingAnalyticsFunction)
  end
end
