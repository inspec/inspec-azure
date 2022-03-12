require 'azure_generic_resources'

class AzurePowerBICapacities < AzureGenericResources
  name 'azure_power_bi_capacities'
  desc 'Retrieves and verifies the settings of all Azure Power BI Capacities.'
  example <<-EXAMPLE
    describe azure_power_bi_capacities do
      it { should exist }
    end
  EXAMPLE

  AUDIENCE = 'https://analysis.windows.net/powerbi/api'.freeze

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_uri] = 'https://api.powerbi.com/v1.0/myorg/capacities'
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:api_version] = 'v1.0'
    super
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzurePowerBICapacities)
  end
end
