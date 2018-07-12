# frozen_string_literal: true

require 'azurerm_resource_groups'

class AzureResourceGroups < AzurermResourceGroups
  name 'azure_resource_groups'
  desc '[DEPRECATED] Please use the azurerm_resource_groups resource'
  example <<-EXAMPLE
    describe azure_resource_groups do
      its('names') { should include('example-group') }
    end
  EXAMPLE

  def initialize
    warn '[DEPRECATION] The `azure_resource_groups` resource is deprecated and will ' \
         'be removed in version 2.0. Use the `azurerm_resource_groups` resource instead.'
    super
  end
end
