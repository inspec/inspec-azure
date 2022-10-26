require 'azure_generic_resource'

class AzureKeyVaultRotationKey < AzureGenericResource
  name 'azure_key_vault_rotation_key'
  desc 'Verifies configuration for an Azure Rotation Key within a Vault.'
  example <<-EXAMPLE
    describe azure_key_vault_rotation_key(vault_name: 'KEY_VAULT_NAME', key_name: 'KEY_NAME') do
      it { should exist }
    end
  EXAMPLE
  
  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    
    # This part is normally done in the backend; however, we need to get the `key_vault_dns_suffix` at the initiation.
    opts[:endpoint] ||= ENV_HASH['endpoint'] || 'azure_cloud'
    unless AzureEnvironments::ENDPOINTS.key?(opts[:endpoint])
      raise ArgumentError, "Invalid endpoint: `#{opts[:endpoint]}`."\
        " Expected one of the following options: #{AzureEnvironments::ENDPOINTS.keys}."
    end
    endpoint = AzureEnvironments.get_endpoint(opts[:endpoint])
    key_vault_dns_suffix = endpoint.key_vault_dns_suffix
    opts[:resource_provider] = specific_resource_constraint(key_vault_dns_suffix, opts)
    
    opts[:required_parameters] = %i(vault_name)
    opts[:resource_identifiers] = %i(key_name)
    opts[:resource_uri] = "https://#{opts[:vault_name]}#{key_vault_dns_suffix}/keys/#{opts[:key_name]}/rotationpolicy"
    opts[:is_uri_a_url] = true
    opts[:audience] = "https://#{key_vault_dns_suffix.delete_prefix('.')}"
    super(opts, true)
  end
  
  def to_s
    super(AzureKeyVaultRotationKey)
  end
end
