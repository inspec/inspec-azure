require 'azure_generic_resources'

class AzurePowerBIDashboards < AzureGenericResources
  name 'azure_power_bi_dashboards'
  desc 'Retrieves and verifies the settings of all Azure Power BI Dashboards.'
  example <<-EXAMPLE
    describe azure_power_bi_dashboards(group_id: '95a4871a-33a4-4f35-9eea-8ff006b4840b') do
      it { should exist }
    end
  EXAMPLE

  AUDIENCE = 'https://analysis.windows.net/powerbi/api'.freeze

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_uri] = ['https://api.powerbi.com/v1.0/myorg'].tap do |arr|
      arr << "groups/#{opts.delete(:group_id)}" if opts[:group_id].present?
      arr << 'dashboards'
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
    super(AzurePowerBIDashboards)
  end
end
