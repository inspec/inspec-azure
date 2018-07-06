# frozen_string_literal: true

require 'azurerm_network_security_groups'

class AzureNetworkSecurityGroups < AzurermNetworkSecurityGroups
  name 'azure_network_security_groups'
  desc '[DEPRECATED] Please use azurerm_network_security_groups'
  example <<-EXAMPLE
    azure_network_security_groups(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  def initialize(resource_group: nil)
    warn '[DEPRECATION] The `azure_network_security_groups` resource is ' \
         'deprecated and will be removed in version 2.0. Use the ' \
         '`azurerm_network_security_groups` resource instead.'
    super
  end
end
