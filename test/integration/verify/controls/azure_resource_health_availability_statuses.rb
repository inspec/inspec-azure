control 'azure_resource_health_availability_statuses' do

  impact 1.0
  title 'Testing the plural resource of azure_resource_health_availability_statuses.'
  desc 'Testing the plural resource of azure_resource_health_availability_statuses.'

  describe azure_resource_health_availability_statuses do
    it { should exist }
    its('locations') { should include 'ukwest' }
  end
end
