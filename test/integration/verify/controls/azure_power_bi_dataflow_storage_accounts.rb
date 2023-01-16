control "verify the settings of all Azure Power BI Dataflow Storage Accounts" do
  describe azure_power_bi_dataflow_storage_accounts do
    it { should exist }
    its("isEnableds") { should include true }
    its("names") { should include "test-dt-storage-account" }
  end
end
