control 'verify the settings of an Azure Power BI Dataset' do
  describe azure_power_bi_dataset(dataset_id: 'cfafbeb1-8037-4d0c-896e-a46fb27ff229') do
    it { should exist }
    its('name') { should eq 'SalesMarketing' }
    its('addRowsAPIEnabled') { should eq false }
    its('isRefreshable') { should eq true }
    its('isEffectiveIdentityRequired') { should eq true }
  end
end
