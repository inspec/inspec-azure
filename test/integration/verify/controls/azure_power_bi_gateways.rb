control 'verify settings of Power BI Gateways' do
  describe azure_power_bi_gateways do
    it { should exist }
    its('types') { should include 'Resource' }
    its('exponents') { should include 'AQAB' }
  end
end
