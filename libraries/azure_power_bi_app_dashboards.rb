require 'azure_generic_resources'

class AzurePowerBIAppDashboards < AzureGenericResources
  name 'azure_power_bi_app_dashboards'
  desc 'Retrieves and verifies the settings of all Azure Power BI App Dashboards.'
  example <<-EXAMPLE
    describe azure_power_bi_app_dashboards(app_id: 'APP_ID') do
      it { should exist }
    end
  EXAMPLE

  AUDIENCE = 'https://analysis.windows.net/powerbi/api'.freeze

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    Validators.validate_parameters(resource_name: @__resource_name__, required: %i(app_id),
                                   opts: opts)

    app_id = opts.delete(:app_id)
    opts[:resource_uri] = "https://api.powerbi.com/v1.0/myorg/apps/#{app_id}/dashboards"
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:api_version] = 'v1.0'
    super
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzurePowerBIAppDashboards)
  end
end
