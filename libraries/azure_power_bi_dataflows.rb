require 'azure_generic_resources'

class AzurePowerBIDataflows < AzureGenericResources
  name 'azure_power_bi_dataflows'
  desc 'Retrieves and verifies the settings of all Azure Power BI Dataflows.'
  example <<-EXAMPLE
    describe azure_power_bi_dataflows(group_id: 'f089354e-8366-4e18-aea3-4cb4a3a50b48') do
      it { should exist }
    end
  EXAMPLE

  AUDIENCE = 'https://analysis.windows.net/powerbi/api'.freeze

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    Validators.validate_parameters(resource_name: @__resource_name__, required: %i(group_id),
                                   opts: opts)

    opts[:resource_uri] = "https://api.powerbi.com/v1.0/myorg/groups/#{opts.delete(:group_id)}/dataflows"
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:api_version] = 'v1.0'
    super
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzurePowerBIDataflows)
  end
end
