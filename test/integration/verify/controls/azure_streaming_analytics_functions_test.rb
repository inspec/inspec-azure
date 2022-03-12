resource_group = input('resource_group', value: nil)
azure_streaming_job_name = input('azure_streaming_job_name', value: nil)

control 'azure_streaming_analytics_functions' do

  impact 1.0
  title 'Testing the plural resource of azure_streaming_analytics_functions.'
  desc 'Testing the plural resource of azure_streaming_analytics_functions.'

  describe azure_streaming_analytics_functions(resource_group: resource_group, job_name: azure_streaming_job_name) do
    it { should exist } # The test itself.
    its('names') { should be_an(Array) }
  end
end
