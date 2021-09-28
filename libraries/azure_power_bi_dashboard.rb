require 'azure_generic_resource'

class AzurePowerBIDashboard < AzureGenericResource
  name 'azure_power_bi_dashboard'
  desc 'Retrieves and verifies the settings of a Data Lake Storage Gen2 file system'
  example <<-EXAMPLE
    describe azure_power_bi_dashboard(dashboard_id: '95a4871a-33a4-4f35', group_id: '95a4871a-33a4-4f35-9eea-8ff006b4840b') do
      it { should exist }
    end
  EXAMPLE

  attr_reader :table

  AUDIENCE = 'https://analysis.windows.net/powerbi/api'.freeze

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    Validators.validate_parameters(resource_name: @__resource_name__, required: %i(dashboard_id),
                                   allow: %i(group_id),
                                   opts: opts)

    opts[:name] = opts.delete(:dashboard_id)
    opts[:resource_uri] = ['https://api.powerbi.com/v1.0/myorg'].tap do |arr|
      arr << "groups/#{opts.delete(:group_id)}" if opts[:group_id].present?
      arr << "dashboards/#{opts[:name]}"
    end.join('/')
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    super
  end

  def to_s
    super(AzurePowerBIDashboard)
  end
end
