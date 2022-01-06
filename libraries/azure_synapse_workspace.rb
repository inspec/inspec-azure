require 'azure_generic_resource'

class AzureSynapseWorkspace < AzureGenericResource
  name 'azure_synapse_workspace'
  desc 'Retrieves and verifies the settings of an Azure Synapse Workspace.'
  example <<-EXAMPLE
    describe azure_synapse_workspace(resource_group: 'inspec-def-rg', name: 'synapse-ws') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Synapse/workspaces', opts)
    super(opts, true)
  end

  def to_s
    super(AzureSynapseWorkspace)
  end
end
