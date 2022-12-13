endpoint = 'https://inspec-workspace.dev.azuresynapse.net'
notebook = 'inspec-notebook'

control 'verifies settings of the azure synapse notebooks' do

  title 'Testing the singular resource of azure_streaming_analytics_function.'
  desc 'Testing the singular resource of azure_streaming_analytics_function.'

  describe azure_synapse_notebook(endpoint: endpoint, name: notebook) do
    it { should exist }
    its('name') { should eq notebook }
    its('type') { should eq 'Microsoft.Synapse/workspaces/notebooks' }
    its('properties.sessionProperties.executorCores') { should eq 4 }
    its('properties.metadata.a365ComputeOptions.sparkVersion') { should eq '2.4' }
  end
end
