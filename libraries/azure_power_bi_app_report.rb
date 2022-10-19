require 'azure_generic_resource'

class AzurePowerBIAppReport < AzureGenericResource
  name 'azure_power_bi_app_report'
  desc 'Retrieves and verifies the settings of a Azure Power BI App Report'
  example <<-EXAMPLE
    describe azure_power_bi_app_report(app_id: 'APP_ID', report_id: 'REPORT_ID') do
      it { should exist }
    end
  EXAMPLE

  AUDIENCE = 'https://analysis.windows.net/powerbi/api'.freeze

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    Validators.validate_parameters(resource_name: @__resource_name__, required: %i(app_id report_id),
                                   opts: opts)
    app_id = opts.delete(:app_id)
    opts[:name] = opts.delete(:report_id)
    opts[:resource_uri] = "https://api.powerbi.com/v1.0/myorg/apps/#{app_id}/reports/#{opts[:name]}"
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:api_version] = 'v1.0'
    super
  end

  def to_s
    super(AzurePowerBIAppReport)
  end
end
