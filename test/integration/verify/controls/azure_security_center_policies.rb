control "azure_security_center_policies" do
  title "Testing the plural resource of azure_security_center_policies."
  desc "Testing the plural resource of azure_security_center_policies."

  describe azure_security_center_policies do
    it                  { should exist }
    its("policy_names") { should include("default") }
  end
end
