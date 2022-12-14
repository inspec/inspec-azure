require "azure_generic_resource"

class AzureKeyVaultSecret < AzureGenericResource
  name "azure_key_vault_secret"
  desc "Verifies configuration for a Secret within a Vault"
  example <<-EXAMPLE
    describe azure_key_vault_secret(vault_name: 'vault-name', secret_name: 'secret-name') do
      it { should exist }
      its('attributes.enabled') { should eq true }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # This part is normally done in the backend; however, we need to get the `key_vault_dns_suffix` at the initiation.
    opts[:endpoint] ||= ENV_HASH["endpoint"] || "azure_cloud"
    unless AzureEnvironments::ENDPOINTS.key?(opts[:endpoint])
      raise ArgumentError, "Invalid endpoint: `#{opts[:endpoint]}`."\
        " Expected one of the following options: #{AzureEnvironments::ENDPOINTS.keys}."
    end
    endpoint = AzureEnvironments.get_endpoint(opts[:endpoint])
    key_vault_dns_suffix = endpoint.key_vault_dns_suffix
    opts[:resource_provider] = specific_resource_constraint(key_vault_dns_suffix, opts)

    if opts[:secret_id]
      opts[:resource_uri] = opts[:secret_id]
    else
      opts[:allowed_parameters] = %i(secret_version)
      opts[:required_parameters] = %i(vault_name)
      opts[:resource_identifiers] = %i(secret_name)
      if opts[:secret_version]
        unless valid_version?(opts[:secret_version])
          raise ArgumentError, "Invalid version '#{opts[:secret_version]}' for secret '#{opts[:secret_name]}'"
        end
        opts[:resource_uri] = "https://#{opts[:vault_name]}#{key_vault_dns_suffix}/secrets/#{opts[:secret_name]}/#{opts[:secret_version]}"
      else
        opts[:resource_uri] = "https://#{opts[:vault_name]}#{key_vault_dns_suffix}/secrets/#{opts[:secret_name]}"
      end
    end
    opts[:is_uri_a_url] = true
    opts[:audience] = "https://#{key_vault_dns_suffix.delete_prefix(".")}"
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureKeyVaultSecret)
  end

  def content_type
    return unless exists?
    contentType
  end

  private

  VALID_VERSION_REGEX = Regexp.new("^([0-9a-f]{32})$")

  def valid_version?(version)
    version.downcase.scan(VALID_VERSION_REGEX).any?
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermKeyVaultSecret < AzureKeyVaultSecret
  name "azurerm_key_vault_secret"
  desc "Verifies configuration for a Secret within a Vault"
  example <<-EXAMPLE
    describe azurerm_key_vault_secret('vault-name', 'secret-name') do
      it { should exist }
      its('attributes.enabled') { should eq true }
    end
  EXAMPLE

  def initialize(vault_name, secret_name, secret_version = nil)
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureKeyVaultSecret.name)
    # This is for backward compatibility.
    opts = {
      vault_name: vault_name,
      secret_name: secret_name,
      api_version: "2016-10-01",
    }
    opts[:secret_version] = secret_version unless secret_version.nil?
    super(opts)
  end
end
