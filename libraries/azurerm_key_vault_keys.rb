# frozen_string_literal: true

require 'azurerm_resource'
require 'json'

class AzurermKeyVaultKeys < AzurermPluralResource
  name 'azurerm_key_vault_keys'
  desc 'Verifies settings for a collection of Azure Keys belonging to a Vault'
  example <<-EXAMPLE
    describe azurerm_key_vault_keys('vault-101') do
        it           { should exist }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
             .register_column(:kids,       field: :kid)
             .register_column(:attributes, field: :attributes)
             .register_column(:managed,    field: :managed) { |table, _value| table[:managed] || false }
             .register_column(:tags,       field: :tags)    { |table, _value| table[:tags] || nil }
             .install_filter_methods_on_resource(self, :table)

  def initialize(vault_name)
    keys = vault(vault_name).keys
    return if has_error?(keys)

    @table = keys
  end

  def to_s
    'Azure KeyVault Keys'
  end
end
