# frozen_string_literal: true

require 'azurerm_resource'

class AzurermKeyVault < AzurermSingularResource
  name 'azurerm_key_vault'
  desc 'Verifies settings and configuration for an Azure Key Vault'
  example <<-EXAMPLE
    describe azurerm_key_vault(resource_group: 'rg-1', vault_name: 'vault-1') do
      it            { should exist }
      its('name')   { should eq('vault-1') }
    end
  EXAMPLE

  ATTRS = %i(
    id
    name
    location
    type
    tags
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, vault_name: nil)
    key_vault = management.key_vault(resource_group, vault_name)
    return if has_error?(key_vault)

    assign_fields(ATTRS, key_vault)

    @exists = true
  end

  def diagnostic_settings
    management.key_vault_diagnostic_settings(id)
  end

  def to_s
    "Azure Key Vault: '#{name}'"
  end
end
