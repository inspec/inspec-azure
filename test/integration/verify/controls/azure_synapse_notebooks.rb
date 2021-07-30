endpoint = 'https://inspec-workspace.dev.azuresynapse.net'
notebook = 'inspec-notebook'

control 'verifies settings of all azure synapse notebooks' do
  describe azure_synapse_notebooks(endpoint: endpoint) do
    it { should exist }
    its('names') { should include notebook }
    its('types') { should include 'Microsoft.Synapse/workspaces/notebooks' }
    its('properties') { should_not be_empty }
  end
end
