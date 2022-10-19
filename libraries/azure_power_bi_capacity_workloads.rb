require 'azure_generic_resources'

class AzurePowerBICapacityWorkloads < AzureGenericResources
  name 'azure_power_bi_capacity_workloads'
  desc 'Retrieves and verifies the settings of all Azure Power BI Capacities Workloads.'
  example <<-EXAMPLE
    describe azure_power_bi_capacity_workloads(capacity_id: 'CAPACITY_ID') do
      it { should exist }
    end
  EXAMPLE

  AUDIENCE = 'https://analysis.windows.net/powerbi/api'.freeze

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    Validators.validate_parameters(resource_name: @__resource_name__, allow: %i(capacity_id), opts: opts)

    opts[:resource_uri] = ['https://api.powerbi.com/v1.0/myorg/capacities'].tap do |arr|
      arr << opts.delete(:capacity_id) if opts[:capacity_id].present?
      arr << 'Workloads'
    end.join('/')
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:api_version] = 'v1.0'
    super
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzurePowerBICapacityWorkloads)
  end
end
