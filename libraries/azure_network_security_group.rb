# frozen_string_literal: true

require 'azurerm_network_security_group'

class AzureNetworkSecurityGroup < AzurermNetworkSecurityGroup
  name 'azure_network_security_group'
  desc 'Verifies settings for Network Security Groups'
  example <<-EXAMPLE
    describe azure_network_security_group(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(resource_group: nil, name: nil)
    warn '[DEPRECATION] The `azure_network_security_group` resource is ' \
         'deprecated and will be removed in version 2.0. Use the ' \
         '`azurerm_network_security_group` resource instead.'
    super
  end
end
