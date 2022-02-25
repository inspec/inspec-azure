require 'azure_generic_resource'

class AzurePowerBICapacityRefreshable < AzureGenericResource
  name 'azure_power_bi_capacity_refreshable'
  desc 'Retrieves and verifies the settings of an Azure Power BI Capacity Refreshable.'
  example <<-EXAMPLE
    describe azure_power_bi_capacity_refreshable(capacity_id: '0f084df7-c13d-451b-af5f-ed0c466403b2', refreshable_id: 'cfafbeb1-8037-4d0c-896e-a46fb27ff229') do
      it { should exist }
    end
  EXAMPLE

  AUDIENCE = 'https://analysis.windows.net/powerbi/api'.freeze

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    Validators.validate_parameters(resource_name: @__resource_name__, required: %i(capacity_id),
                                   opts: opts)

    opts[:resource_uri] = "https://api.powerbi.com/v1.0/myorg/capacities/#{opts.delete(:capacity_id)}/refreshables/#{opts.delete(:name)}"
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:api_version] = 'v1.0'
    super
  end

  def to_s
    super(AzurePowerBICapacityRefreshable)
  end
end
