resource_group = attribute('resource_group', default: nil)
container_registry_name = attribute('container_registry_name', default: nil)

control 'azure_container_registries' do

  describe azure_container_registries(resource_group: resource_group) do
    it           { should exist }
    its('names') { should include container_registry_name }
  end

  describe azure_container_registries do
    it            { should exist }
    its('names')  { should include container_registry_name }
  end
end
