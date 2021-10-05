require 'azure_generic_resources'

class AzurePowerBIGateways < AzureGenericResources
  name 'azure_power_bi_gateways'
  desc 'Retrieves and verifies the settings of all Azure Power BI Gateways.'
  example <<-EXAMPLE
    describe azure_power_bi_gateways do
      it { should exist }
    end
  EXAMPLE

  AUDIENCE = 'https://analysis.windows.net/powerbi/api'.freeze

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_uri] = 'https://api.powerbi.com/v1.0/myorg/gateways'
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:api_version] = 'v1.0'
    super
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzurePowerBIGateways)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:publicKey])
    end
  end
end
