# frozen_string_literal: true

require 'azurerm_security_center_policy'

class AzureSecurityCenterPolicy < AzurermSecurityCenterPolicy
  name 'azure_security_center_policy'
  desc '[DEPRECATED] Please use the azurerm_security_center_policy resource'
  example <<-EXAMPLE
    describe azure_security_center_policy(name: 'default') do
      its('log_collection') { should eq('On') }
    end
  EXAMPLE

  def initialize(*args)
    warn '[DEPRECATION] The `azure_security_center_policy` resource is ' \
         'deprecated and will be removed in version 2.0. Use the ' \
         '`azurerm_security_center_policy` resource instead.'
    super
  end
end
