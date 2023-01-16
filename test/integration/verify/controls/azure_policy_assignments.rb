control "azure_policy_assignments" do

  title "Testing the plural resource of azure_policy_assignments."
  desc "Testing the plural resource of azure_policy_assignments."

  describe azure_policy_assignments do
    it { should exist }
    its("names.class") { should eq "Array" }
    its("displayNames.class") { should eq "Array" }
  end
end
