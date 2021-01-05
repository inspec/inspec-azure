control 'azurerm_ad_users' do

  describe azurerm_ad_users do
    its('display_names')       { should_not be_empty }
    its('user_types')          { should_not be_empty }
    its('mails')               { should_not be_empty }
  end
end
