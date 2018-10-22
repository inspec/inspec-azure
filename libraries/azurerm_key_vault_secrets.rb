# frozen_string_literal: true

require 'azurerm_resource'
require 'json'

class AzurermKeyVaultSecrets < AzurermPluralResource
  name 'azurerm_key_vault_secrets'
  desc 'Verifies settings for a collection of Azure Secrets within to a Vault'
  example <<-EXAMPLE
    describe azurerm_key_vault_secrets('vault-101') do
        it { should exist }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
             .register_column(:ids,          field: :id)
             .register_column(:attributes,   field: :attributes)
             .register_column(:contentTypes, field: :contentType) { |table, _| table[:contentType] || nil }
             .register_column(:managed,      field: :managed)     { |table, _| table[:managed] || false }
             .register_column(:tags,         field: :tags)        { |table, _| table[:tags] || nil }
             .install_filter_methods_on_resource(self, :table)

  def initialize(vault_name)
    secrets = vault(vault_name).secrets
    return if has_error?(secrets)

    @table = secrets
  end

  def to_s
    'Azure KeyVault Secrets'
  end
end
