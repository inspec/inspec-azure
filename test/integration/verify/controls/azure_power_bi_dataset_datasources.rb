control 'verify the settings of all Azure Power BI Dataset Datasources' do
  describe azure_power_bi_dataset_datasources(dataset_id: 'cfafbeb1-8037-4d0c-896e-a46fb27ff229') do
    it { should exist }
    its('datasourceTypes') { should include 'AnalysisServices' }
    its('datasourceIds') { should include '33cc5222-3fb9-44f7-b19d-ffbff18aaaf5' }
    its('gatewayIds') { should include '0a2dafe6-0e93-4120-8d2c-fae123c111b1' }
  end
end
