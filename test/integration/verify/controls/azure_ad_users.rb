
control 'azure_ad_users' do

  title 'Ensure no Guest Users are present within an Active Directory Tenant'

  describe azure_ad_users.each do |user|
    describe azure_ad_user(object_id: nil, user_args: user) do
      it { should_not be_guest }
    end
  end
end
