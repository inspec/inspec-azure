require 'azure_generic_resource'

class AzurePowerBIAppDashboard < AzureGenericResource
  name 'azure_power_bi_app_dashboard'
  desc 'Retrieves and verifies the settings of a Azure Power BI App Dashboard'
  example <<-EXAMPLE
    describe azure_power_bi_app_dashboard(app_id: 'f089354e-8366-4e18-aea3-4cb4a3a50b48', dashboard_id: '335aee4b-7b38-48fd-9e2f-306c3fd67482') do
      it { should exist }
    end
  EXAMPLE

  attr_reader :table

  AUDIENCE = 'https://analysis.windows.net/powerbi/api'.freeze

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    Validators.validate_parameters(resource_name: @__resource_name__, required: %i(app_id dashboard_id),
                                   opts: opts)
    app_id = opts.delete(:app_id)
    opts[:name] = opts.delete(:dashboard_id)
    opts[:resource_uri] = "https://api.powerbi.com/v1.0/myorg/apps/#{app_id}/dashboards/#{opts[:name]}"
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:api_version] = 'v1.0'
    super
  end

  def to_s
    super(AzurePowerBIAppDashboard)
  end
end
