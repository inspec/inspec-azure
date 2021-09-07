require 'azure_generic_resource'

class AzureSynapseNotebook < AzureGenericResource
  name 'azure_synapse_notebook'
  desc 'Verifies settings of a Azure Synapse Notebook'
  example <<-EXAMPLE
    describe azure_synapse_notebook(endpoint: 'https://analytics.dev.azuresynapse.net', name: 'my-analytics-notebook') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    Validators.validate_parameters(required: [:endpoint, :name], opts: opts)
    endpoint = opts.delete(:endpoint).chomp('/')
    opts[:resource_uri] = [endpoint, 'notebooks'].join('/')
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:audience] = 'https://dev.azuresynapse.net/'
    super(opts, true)

    create_resource_methods(@resource_long_desc[:value]&.first)
  end

  def to_s
    super(AzureSynapseNotebook)
  end
end
