require 'azure_generic_resources'

class AzureSynapseWorkspaces < AzureGenericResources
  name 'azure_synapse_workspaces'
  desc 'Verifies settings for a collection of Azure Synapse Workspaces'
  example <<-EXAMPLE
    describe azure_synapse_workspaces do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Synapse/workspaces', opts)
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureSynapseWorkspaces)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:properties])
                        .merge(resource.dig(:properties, :defaultDataLakeStorage))
                        .merge(resource.dig(:properties, :connectivityEndpoints))
    end
  end
end
