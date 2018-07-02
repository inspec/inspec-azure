resource_group = attribute('resource_group', default: nil)

control 'azure_resource_groups' do
  describe azure_resource_groups do
    it           { should exist }
    its('names') { should include(resource_group) }
  end
end
