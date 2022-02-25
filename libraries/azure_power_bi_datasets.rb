require 'azure_generic_resources'

class AzurePowerBIDatasets < AzureGenericResources
  name 'azure_power_bi_datasets'
  desc 'Retrieves and verifies the settings of all Azure Power BI Datasets.'
  example <<-EXAMPLE
    describe azure_power_bi_datasets do
      it { should exist }
    end
  EXAMPLE

  AUDIENCE = 'https://analysis.windows.net/powerbi/api'.freeze

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    Validators.validate_parameters(resource_name: @__resource_name__, allow: %i(group_id),
                                   opts: opts)

    opts[:resource_uri] = ['https://api.powerbi.com/v1.0/myorg'].tap do |array|
      if opts[:group_id].present?
        array << 'groups'
        array << opts.delete(:group_id)
      end
      array << 'datasets'
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
    super(AzurePowerBIDatasets)
  end
end
