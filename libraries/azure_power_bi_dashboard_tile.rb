require "azure_generic_resource"

class AzurePowerBIDashboardTile < AzureGenericResource
  name "azure_power_bi_dashboard_tile"
  desc "Retrieves and verifies the settings of a Azure Power BI Dashboard tile"
  example <<-EXAMPLE
    describe azure_power_bi_dashboard_tile(tile_id: '3262-4671-bdc8', dashboard_id: 'b84b01c6-3262-4671-bdc8-ff99becf2a0b', group_id: '95a4871a-33a4-4f35-9eea-8ff006b4840b') do
      it { should exist }
    end
  EXAMPLE

  attr_reader :table

  AUDIENCE = "https://analysis.windows.net/powerbi/api".freeze

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    Validators.validate_parameters(resource_name: @__resource_name__, required: %i(tiles_id dashboard_id),
                                   allow: %i(group_id),
                                   opts: opts)

    opts[:name] = opts.delete(:dashboard_id)
    opts[:resource_uri] = ["https://api.powerbi.com/v1.0/myorg"].tap do |arr|
      arr << "groups/#{opts.delete(:group_id)}" if opts[:group_id].present?
      arr << "dashboards/#{opts[:name]}"
      arr << "tiles/#{opts[:tiles_id]}"
    end.join("/")
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:api_version] = "v1.0"
    super
  end

  def to_s
    super(AzurePowerBIDashboardTile)
  end
end
