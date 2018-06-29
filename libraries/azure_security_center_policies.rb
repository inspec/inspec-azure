# frozen_string_literal: true

require 'azurerm_resource'

class AzureSecurityCenterPolicies < AzurermResource
  name 'azure_security_center_policies'
  desc 'Verifies settings for Security Center'
  example "
    describe azure_security_center_policies do
      its('policy_names') { should include('default') }
    end
  "

  FilterTable.create
             .add_accessor(:entries)
             .add_accessor(:where)
             .add(:exists?) { |obj| !obj.entries.empty? }
             .add(:policy_names, field: 'name')
             .connect(self, :table)

  def to_s
    'Security Policies'
  end

  def table
    @table ||= client.security_center_policies
  end
end
