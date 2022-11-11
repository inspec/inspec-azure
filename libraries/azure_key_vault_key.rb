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
    opts[:api_version] ||= "7.3"
    key_vault_dns_suffix = endpoint.key_vault_dns_suffix
    opts[:resource_provider] = specific_resource_constraint(key_vault_dns_suffix, opts)
    if opts[:key_id]
      opts[:resource_uri] = opts[:key_id]
    else
      opts[:allowed_parameters] = %i(key_version api_version)
      opts[:required_parameters] = %i(vault_name)
      opts[:resource_identifiers] = %i(key_name)
      if opts[:key_version]
        unless valid_version?(opts[:key_version])
          raise ArgumentError, "Invalid version '#{opts[:key_version]}' for key '#{opts[:key_name]}'"
        end
        opts[:resource_uri] = "https://#{opts[:vault_name]}#{key_vault_dns_suffix}/keys/#{opts[:key_name]}/#{opts[:key_version]}"
      else
        opts[:resource_uri] = "https://#{opts[:vault_name]}#{key_vault_dns_suffix}/keys/#{opts[:key_name]}"
      end
    end
    opts[:is_uri_a_url] = true
    opts[:audience] = "https://#{key_vault_dns_suffix.delete_prefix('.')}"
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
    rotation_policy
  end

  def to_s
    super(AzureKeyVaultKey)
  end

  def rotation_policy
    return unless exists?
    resource_uri = "#{@opts[:resource_uri]}/rotationpolicy"
    query = {
      resource_uri: resource_uri,
      query_parameters: { api_version: @opts[:api_version] },
      is_uri_a_url: true,
    }
    require 'pry';binding.pry
    policy = get_resource(query)[:value]&.map { |c| [c[:name], c] }.to_h
    create_resource_methods({ rotation_policy: policy })
  end

  # def rotation_policy
  #   return unless exists?
  #   # `additional_resource_properties` method will create a singleton method with the `property_name`
  #   # and make api response available through this property.
  #   additional_resource_properties(
  #     {
  #       property_name: 'rotation_policy',
  #       property_endpoint: "#{id}/rotationpolicy",
  #       api_version: @opts[:api_version],
  #     },
  #     )
  # end

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

  def initialize(vault_name, key_name, key_version = nil)
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureKeyVaultKey.name)
    # This is for backward compatibility.
    opts = {
      vault_name: vault_name,
        key_name: key_name,
        api_version: '2016-10-01',
    }
    opts[:key_version] = key_version unless key_version.nil?
    super(opts)
  end
end
