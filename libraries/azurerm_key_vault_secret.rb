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

  # TODO : The API (https://docs.microsoft.com/en-us/rest/api/keyvault/getsecret/getsecret)
  # currently returns only the Value of the Secret, not the entire SecretBundle object
  # as documented.
  # TODO : Link to issue. When issue is resolved, bring this resource in line with the
  # standards of other singular resources.
  attr_reader :secret_name, :value

  def initialize(vault_name, secret_name, secret_version = nil)
    secret_version ||= vault(vault_name).secret_versions(secret_name)
                                        .sort_by! { |obj| obj.attributes.created }.last
                                        .id.partition("/secrets/#{secret_name}/").last

    raise ArgumentError, "Invalid version '#{secret_version}' for secret '#{secret_name}'" unless valid_version?(secret_version)

    response = vault(vault_name).secret(secret_name, secret_version)

    return if has_error?(response)

    @secret_name = secret_name
    @value = response

    @exists = true
  end

  def to_s
    "Azure Key Vault Secret: '#{@secret_name}'"
  end

  private

  VALID_VERSION_REGEX = Regexp.new('^([0-9a-f]{32})$')

  def valid_version?(version)
    version.downcase
           .scan(VALID_VERSION_REGEX)
           .any?
  end
end
