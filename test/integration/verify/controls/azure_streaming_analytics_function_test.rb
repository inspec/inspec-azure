resource_group = input('resource_group', value: nil)
azure_streaming_job_name = input('azure_streaming_job_name', value: nil)
azure_streaming_job_function_name = input('azure_streaming_job_function_name', value: nil)

control 'azure_streaming_analytics_function' do

  impact 1.0
  title 'Testing the singular resource of azure_streaming_analytics_function.'
  desc 'Testing the singular resource of azure_streaming_analytics_function.'

  describe azure_streaming_analytics_function(resource_group: resource_group, job_name: azure_streaming_job_name, function_name: azure_streaming_job_function_name) do
    it { should exist } # The test itself.
    its('name')                                         { should cmp azure_streaming_job_function_name }
    its('type')                                         { should cmp 'Microsoft.StreamAnalytics/streamingjobs/functions' }
    its('properties.type')                              { should cmp 'Scalar' }
    its('properties.properties.output.dataType')        { should cmp 'bigint' }
  end
end
