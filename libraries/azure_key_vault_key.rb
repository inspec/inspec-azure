require 'azure_generic_resource'

class AzureKeyVaultKey < AzureGenericResource
  name 'azure_key_vault_key'
  desc 'Verifies configuration for an Azure Key within a Vault'
  example <<-EXAMPLE
    describe azure_key_vault_key(vault_name: 'vault-101', key_name: 'key') do
      it { should exist }
      its('attributes.enabled') { should eq true }
    end
  EXAMPLE

  def initialize(*args)
    opts = {}
    # For backward compatibility.
    if args.size.between?(2, 3)
      opts[:vault_name] = args[0]
      opts[:key_name] = args[1]
      opts[:key_version] = args[2] unless args.size == 3
    elsif args.size == 1
      # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
      raise ArgumentError, 'Parameters must be provided in an Hash object.' unless args[0].is_a?(Hash)
      opts = args[0]
    end
    if opts[:key_version]
      unless valid_version?(opts[:key_version])
        raise ArgumentError, "Invalid version '#{opts[:key_version]}' for key '#{opts[:key_version]}'"
      end
    end
    opts[:allowed_parameters] = %i(is_uri_a_url vault_name audience key_name)
    opts[:resource_identifiers] = %i(key_name)

    # This part normally is done in the backend, however, we need to get the `key_vault_dns_suffix` at the initiation.
    opts[:endpoint] ||= ENV_HASH['endpoint'] || 'azure_cloud'
    unless AzureEnvironments::ENDPOINTS.key?(opts[:endpoint])
      raise ArgumentError, "Invalid endpoint: `#{opts[:endpoint]}`."\
        " Expected one of the following options: #{AzureEnvironments::ENDPOINTS.keys}."
    end
    endpoint = AzureEnvironments.get_endpoint(opts[:endpoint])
    key_vault_dns_suffix = endpoint.key_vault_dns_suffix
    opts[:resource_provider] = key_vault_dns_suffix
    opts[:resource_uri] = "https://#{opts[:vault_name]}#{key_vault_dns_suffix}/keys/#{opts[:key_name]}"
    opts[:is_uri_a_url] = true
    opts[:audience] = 'https://vault.azure.net'
    opts[:api_version] ||= '7.1'
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureKeyVaultKey)
  end

  private

  VALID_VERSION_REGEX = Regexp.new('^([0-9a-f]{32})$')

  def valid_version?(version)
    version.downcase.scan(VALID_VERSION_REGEX).any?
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermKeyVaultKey < AzureKeyVaultKey
  name 'azurerm_key_vault_key'
  desc 'Verifies configuration for an Azure Key within a Vault'
  example <<-EXAMPLE
    describe azurerm_key_vault_key('vault-101', 'key') do
      it { should exist }
      its('attributes.enabled') { should eq true }
    end
  EXAMPLE

  def initialize(*args)
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureKeyVaultKey.name)
    super
  end
end
