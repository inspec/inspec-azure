control 'verify the settings of all Azure Power BI Datasets' do
  describe azure_power_bi_datasets do
    it { should exist }
    its('names') { should include 'SalesMarketing' }
    its('addRowsAPIEnableds') { should include false }
    its('isRefreshables') { should include true }
    its('isEffectiveIdentityRequireds') { should include true }
  end
end
