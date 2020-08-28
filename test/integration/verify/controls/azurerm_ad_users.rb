guest_accounts = input('guest_accounts', value: nil)

control 'azurerm_ad_users' do
  only_if { ENV['GRAPH'] }

  describe azurerm_ad_users do
    its('display_names')       { should_not be_empty }
    its('user_types')          { should_not be_empty }
    its('mails')               { should_not be_empty }
    its('guest_accounts.size') { should cmp guest_accounts }
  end

  describe azurerm_ad_users(filter: "userType eq 'Guest'") do
    its('guest_accounts.size') { should cmp guest_accounts }
  end
end
