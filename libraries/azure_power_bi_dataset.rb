require 'azure_generic_resource'

class AzurePowerBIDataset < AzureGenericResource
  name 'azure_power_bi_dataset'
  desc 'Retrieves and verifies the settings of an Azure Power BI Dataset.'
  example <<-EXAMPLE
    describe azure_power_bi_dataset(group_id: '0f084df7-c13d-451b-af5f-ed0c466403b2', name: 'cfafbeb1-8037-4d0c-896e-a46fb27ff229') do
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
      array << opts[:name]
    end.join('/')
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:api_version] = 'v1.0'
    super
  end

  def to_s
    super(AzurePowerBIDataset)
  end
end
