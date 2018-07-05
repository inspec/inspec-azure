
control 'azure_ad_users' do

  title 'Ensure no Guest Users are present within an Active Directory Tenant'

  describe azure_ad_users.table.each {
    |user| describe azure_ad_user(nil, user) do
      it { should_not be_guest }
    end
  }
end
