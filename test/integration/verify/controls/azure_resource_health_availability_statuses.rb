control 'azure_resource_health_availability_statuses' do
  describe azure_resource_health_availability_statuses do
    it { should exist }
    its('locations') { should include 'ukwest' }
  end
end
