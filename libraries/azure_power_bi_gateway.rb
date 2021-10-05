require 'azure_generic_resource'

class AzurePowerBIGateway < AzureGenericResource
  name 'azure_power_bi_gateway'
  desc 'Retrieves and verifies the settings of a Azure Power BI Gateway'
  example <<-EXAMPLE
    describe azure_power_bi_gateway(gateway_id: '95a4871a-33a4-4f35-9eea-8ff006b4840b') do
      it { should exist }
    end
  EXAMPLE

  attr_reader :table

  AUDIENCE = 'https://analysis.windows.net/powerbi/api'.freeze

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    Validators.validate_parameters(resource_name: @__resource_name__, required: %i(gateway_id),
                                   opts: opts)

    opts[:name] = opts.delete(:gateway_id)
    opts[:resource_uri] = "https://api.powerbi.com/v1.0/myorg/gateways/#{opts[:name]}"
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:api_version] = 'v1.0'
    super
  end

  def to_s
    super(AzurePowerBIGateway)
  end
end
