resource_group = attribute('resource_group', default: nil)

control 'azurerm_security_center_policy' do
  desc <<-DESC
    This control is asserting state on global settings outside the control of
    Terraform. I will only be asserting on the expectation that things will be
    'on' or 'off' for recommendations and 'true' or 'false' for some other
    properties.

    Non boolean properties will just assert that they are not `nil`.

    Security Policy names match resource group names.
  DESC

  describe azurerm_security_center_policy(name: 'default') do
    it                                     { should exist }
    its('id')                              { should eq("/subscriptions/#{ENV['AZURE_SUBSCRIPTION_ID']}/providers/Microsoft.Security/policies/default") }
    its('name')                            { should eq('default') }
    its('log_collection')                  { should eq('On').or eq('Off') }
    its('pricing_tier')                    { should eq('Standard').or eq('Free') }
    its('patch')                           { should eq('On').or eq('Off') }
    its('baseline')                        { should eq('On').or eq('Off') }
    its('anti_malware')                    { should eq('On').or eq('Off') }
    its('disk_encryption')                 { should eq('On').or eq('Off') }
    its('network_security_groups')         { should eq('On').or eq('Off') }
    its('web_application_firewall')        { should eq('On').or eq('Off') }
    its('next_generation_firewall')        { should eq('On').or eq('Off') }
    its('vulnerability_assessment')        { should eq('On').or eq('Off') }
    its('just_in_time_network_access')     { should eq('On').or eq('Off') }
    its('app_whitelisting')                { should eq('On').or eq('Off') }
    its('sql_auditing')                    { should eq('On').or eq('Off') }
    its('sql_transparent_data_encryption') { should eq('On').or eq('Off') }
    its('notifications_enabled')           { should eq(true).or eq(false) }
    its('send_security_email_to_admin')    { should eq(true).or eq(false) }
    its('contact_emails')                  { should_not be_nil }
    its('contact_phone')                   { should_not be_nil }
  end

  # only supports looking up the security center policy named 'default'
  describe azurerm_security_center_policy(name: resource_group) do
    it { should_not exist }
  end
end
