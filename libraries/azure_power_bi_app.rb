require 'azure_generic_resource'

class AzurePowerBIApp < AzureGenericResource
  name 'azure_power_bi_app'
  desc 'Retrieves and verifies the settings of a Azure Power BI Gateway'
  example <<-EXAMPLE
    describe azure_power_bi_app(app_id: 'f089354e-8366-4e18-aea3-4cb4a3a50b48') do
      it { should exist }
    end
  EXAMPLE

  attr_reader :table

  AUDIENCE = 'https://analysis.windows.net/powerbi/api'.freeze

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    Validators.validate_parameters(resource_name: @__resource_name__, required: %i(app_id),
                                   opts: opts)

    opts[:name] = opts.delete(:app_id)
    opts[:resource_uri] = "https://api.powerbi.com/v1.0/myorg/apps/#{opts[:name]}"
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:api_version] = 'v1.0'
    super
  end

  def to_s
    super(AzurePowerBIApp)
  end
end
