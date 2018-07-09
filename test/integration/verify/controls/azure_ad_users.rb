
control 'azure_ad_users' do

  title 'Ensure no Guest Users are present within an Active Directory Tenant'

  # TODO which?

  # Slow, API call per User
  # describe azure_ad_users.data.map{|user| user["objectId"]}.each { |id|
  #   describe azure_ad_user(id) do
  #     it { should exist}
  #     it { should_not be_guest }
  #   end
  # }

  # Fast, does not tell which User failed the control.
  # describe azure_ad_users.data.map{|user| user["userType"]} do
  #     it { should_not include 'Guest' }
  # end
end
