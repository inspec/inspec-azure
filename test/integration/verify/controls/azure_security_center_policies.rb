resource_group = attribute('resource_group', default: nil)

control 'azure_security_center_policies' do
  describe azure_security_center_policies do
    it                  { should exist }
    its('policy_names') { should include('default', resource_group) }
  end

  describe azure_security_center_policies.where('name' => resource_group) do
    it                  { should exist }
    its('policy_names') { should eq([resource_group]) }
  end
end
