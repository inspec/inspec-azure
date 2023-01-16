control "azurerm_ad_users" do

  title "Testing the plural resource of azurerm_ad_users."
  desc "Testing the plural resource of azurerm_ad_users."

  describe azurerm_ad_users do
    its("display_names")       { should_not be_empty }
    its("user_types")          { should_not be_empty }
    its("mails")               { should_not be_empty }
  end
end
