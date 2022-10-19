require 'azure_generic_resource'

class AzurePowerBICapacityWorkload < AzureGenericResource
  name 'azure_power_bi_capacity_workload'
  desc 'Retrieves and verifies the settings of an Azure Power BI Capacity Workload.'
  example <<-EXAMPLE
    describe azure_power_bi_capacity_workload(capacity_id: 'CAPACITY_ID', name: 'DEMO_NAME') do
      it { should exist }
    end
  EXAMPLE

  AUDIENCE = 'https://analysis.windows.net/powerbi/api'.freeze

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    Validators.validate_parameters(resource_name: @__resource_name__, required: %i(capacity_id),
                                   opts: opts)

    opts[:resource_uri] = "https://api.powerbi.com/v1.0/myorg/capacities/#{opts.delete(:capacity_id)}/Workloads/#{opts.delete(:name)}"
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:api_version] = 'v1.0'
    super
  end

  def to_s
    super(AzurePowerBICapacityWorkload)
  end
end
