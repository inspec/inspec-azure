# frozen_string_literal: true

require 'azurerm_resource'

class AzurermKeyVaultKey < AzurermSingularResource
  name 'azurerm_key_vault_key'
  desc 'Verifies configuration for an Azure Key within a Vault'
  example <<-EXAMPLE
    describe azurerm_key_vault_key(key_name: 'key', key_version: '1a8e0148bf84') do
      it                        { should exist }
      its('attributes.enabled') { should eq true }
    end
  EXAMPLE

  ATTRS = %i(
    attributes
    key
    managed
    tags
  ).freeze

  attr_reader(*ATTRS)

  def initialize(key_name, key_version)
    key = vault.key(key_name, key_version)
    return if has_error?(key)

    assign_fields(ATTRS, key)

    @exists = true
  end

  def to_s
    "Azure Key Vault Key: '#{attributes.kid}'"
  end
end
