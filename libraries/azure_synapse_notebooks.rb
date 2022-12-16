require "azure_generic_resources"

class AzureSynapseNotebooks < AzureGenericResources
  name "azure_synapse_notebooks"
  desc "Verifies settings for the Azure Synapse Notebooks within a tenant"
  example <<-EXAMPLE
    describe azure_synapse_notebooks(endpoint: 'https://analytics.dev.azuresynapse.net') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    Validators.validate_parameters(required: [:endpoint], opts: opts)
    endpoint = opts.delete(:endpoint).chomp("/")
    opts[:resource_uri] = [endpoint, "notebooks"].join("/")
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:audience] = "https://dev.azuresynapse.net/"
    super(opts)

    return if failed_resource?

    table_schema = [
      { column: :ids, field: :id },
      { column: :names, field: :name },
      { column: :types, field: :type },
      { column: :properties, field: :property },
    ]

    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureSynapseNotebooks)
  end
end
