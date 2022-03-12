require 'azure_generic_resources'

class AzurePowerBICapacityRefreshables < AzureGenericResources
  name 'azure_power_bi_capacity_refreshables'
  desc 'Retrieves and verifies the settings of all Azure Power BI Capacities Refreshables.'
  example <<-EXAMPLE
    describe azure_power_bi_capacity_refreshables(capacity_id: '0f084df7-c13d-451b-af5f-ed0c466403b2') do
      it { should exist }
    end
  EXAMPLE

  AUDIENCE = 'https://analysis.windows.net/powerbi/api'.freeze

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    Validators.validate_parameters(resource_name: @__resource_name__, allow: %i(capacity_id top), opts: opts)

    opts[:resource_uri] = ['https://api.powerbi.com/v1.0/myorg/capacities'].tap do |arr|
      arr << opts.delete(:capacity_id) if opts[:capacity_id].present?
      arr << 'refreshables'
    end.join('/')
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:api_version] = 'v1.0'
    opts[:query_parameters] = { '$top' => opts.delete(:top) || 1000 }
    super
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzurePowerBICapacityRefreshables)
  end
end
