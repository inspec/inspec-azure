control "azurerm_ad_user" do

  title "Testing the singular resource of azurerm_ad_user."
  desc "Testing the singular resource of azurerm_ad_user."

  user_id = azurerm_ad_users.object_ids.first
  describe azurerm_ad_user(user_id: user_id) do
    it                    { should exist }
    its("objectId")       { should eq user_id }
    its("displayName")    { should_not be_nil }
    its("userType")       { should_not be_nil }
    its("accountEnabled") { should_not be_nil }
  end
end
