control 'verify settings of Power BI Gateways' do

  impact 1.0
  title 'Testing the plural resource of azure_power_bi_gateways.'
  desc 'Testing the plural resource of azure_power_bi_gateways.'

  describe azure_power_bi_gateways do
    it { should exist }
    its('types') { should include 'Resource' }
    its('exponents') { should include 'AQAB' }
  end
end
