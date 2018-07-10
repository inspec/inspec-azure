control 'azure_ad_users' do

  title 'Ensure no Guest Users are present within an Active Directory Tenant'

  describe azurerm_ad_users.guest_accounts do
    it { should_not exist }
  end

end
