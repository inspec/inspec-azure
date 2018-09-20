# frozen_string_literal: true

require 'azurerm_resource'

class AzurermKeyVaultKey < AzurermSingularResource
  name 'azurerm_key_vault_key'
  desc 'Verifies configuration for an Azure Key within a Vault'
  example <<-EXAMPLE
    describe azurerm_key_vault_key('vault-101', 'key') do
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

  def initialize(vault_name, key_name, key_version = nil)
    key_version ||= vault(vault_name).key_versions(key_name)
                                     .sort_by! { |obj| obj.attributes.created }.last
                                     .kid.partition("/keys/#{key_name}/").last

    raise ArgumentError, "Invalid version '#{key_version}' for key '#{key_name}'" unless valid_version?(key_version)

    key = vault(vault_name).key(key_name, key_version)

    return if has_error?(key)

    assign_fields(ATTRS, key)

    @exists = true
  end

  private

  VALID_VERSION_REGEX = Regexp.new('^([0-9a-f]{8})([0-9a-f]{4})([0-9a-f]{4})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{12})$')

  def valid_version?(version)
    version.downcase
           .scan(VALID_VERSION_REGEX)
           .any?
  end

  def to_s
    "Azure Key Vault Key: '#{key.kid}'"
  end
end
