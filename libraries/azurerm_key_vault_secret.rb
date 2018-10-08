# frozen_string_literal: true

require 'azurerm_resource'

class AzurermKeyVaultSecret < AzurermSingularResource
  name 'azurerm_key_vault_secret'
  desc 'Verifies configuration for a Secret within a Vault'
  example <<-EXAMPLE
    describe azurerm_key_vault_secret('vault-name', 'secret-name') do
      it                        { should exist }
      its('attributes.enabled') { should eq true }
    end
  EXAMPLE

  ATTRS = %i(
    id
    value
    attributes
    kid
    content_type
    managed
    tags
  ).freeze

  attr_reader(*ATTRS)

  def initialize(vault_name, secret_name, secret_version = nil)
    secret_version ||= secret_version(vault_name, secret_name)

    raise ArgumentError, "Invalid version '#{secret_version}' for secret '#{secret_name}'" unless valid_version?(secret_version)

    secret = vault(vault_name).secret(secret_name, secret_version)

    return if has_error?(secret)

    assign_fields(ATTRS, secret)

    @exists = true
  end

  def to_s
    "Azure Key Vault Secret: '#{id}'"
  end

  private

  VALID_VERSION_REGEX = Regexp.new('^([0-9a-f]{32})$')

  def valid_version?(version)
    version.downcase.scan(VALID_VERSION_REGEX).any?
  end

  def secret_version(vault_name, secret_name)
    vault(vault_name).secret_versions(secret_name)
                     .max_by { |obj| obj.attributes.created }
                     .id.partition("/secrets/#{secret_name}/").last
  end
end
