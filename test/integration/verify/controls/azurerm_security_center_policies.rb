control 'azurerm_security_center_policies' do
  describe azurerm_security_center_policies do
    it                  { should exist }
    its('policy_names') { should include('default') }
  end
end
