# frozen_string_literal: true

require 'azurerm_security_center_policies'

class AzureSecurityCenterPolicies < AzurermSecurityCenterPolicies
  name 'azure_security_center_policies'
  desc '[DEPRECATED] Please use the azurerm_security_center_policies resource'
  example <<-EXAMPLE
    describe azure_security_center_policies do
      its('policy_names') { should include('default') }
    end
  EXAMPLE

  def initialize
    warn '[DEPRECATION] The `azure_security_center_policies` resource is ' \
         'deprecated and will be removed in version 2.0. Use the ' \
         '`azurerm_security_center_policies` resource instead.'
    super
  end
end
