require 'azure_generic_resources'

class AzurePowerBIGenericResources < AzureGenericResources
  name 'azure_power_bi_generic_resources'
  desc 'Retrieves and verifies the settings of all Azure Power BI Resources.'
  example <<-EXAMPLE
    describe azure_power_bi_generic_resources do
      it { should exist }
    end
  EXAMPLE

  AUDIENCE = 'https://analysis.windows.net/powerbi/api'.freeze

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    Validators.validate_parameters(resource_name: @__resource_name__, allow: %i(group_id resource_path_array),
                                   opts: opts)
    opts[:resource_uri] ||= ['https://api.powerbi.com/v1.0/myorg'].tap do |array|
      if opts[:group_id].present?
        array << 'groups'
        array << opts.delete(:group_id)
      end
      array << opts.delete(:resource_path_array) if opts[:resource_path_array]
    end.join('/')
    opts[:audience] = self.class::AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:api_version] = 'v1.0'
    super
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzurePowerBIGenericResources)
  end
end
