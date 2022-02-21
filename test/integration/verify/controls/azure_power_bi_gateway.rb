gateway_id = input(:gateway_id, value: '')
control 'Verify settings of a Power BI Dashboard' do
  describe azure_power_bi_gateway(gateway_id: gateway_id) do
    it { should exist }
    its('type') { should eq 'Resource' }
    its('publicKey.exponent') { should eq 'AQAB' }
  end
end
