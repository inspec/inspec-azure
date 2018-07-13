# frozen_string_literal: true

require 'azurerm_resource'

class AzurermSecurityCenterPolicies < AzurermResource
  name 'azurerm_security_center_policies'
  desc 'Verifies settings for Security Center'
  example <<-EXAMPLE
    describe azurerm_security_center_policies do
      its('policy_names') { should include('default') }
    end
  EXAMPLE

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
