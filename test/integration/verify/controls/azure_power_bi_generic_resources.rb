control "Verify the settings of azure_power_bi_generic_resources" do
  title "Testing the plural resource of azure_power_bi_generic_resources."
  desc "Testing the plural resource of azure_power_bi_generic_resources."

  describe azure_power_bi_generic_resources do
    it { should exist }
  end
end
