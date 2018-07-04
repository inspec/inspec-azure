control 'azure_ad_users' do
  describe azure_ad_users.each do |user|
    describe azure_ad_user(object_id: nil, user_args: user) do
      it { should_not be_guest }
    end
  end
end
