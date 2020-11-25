require 'azure_generic_resource'


class AzureKeyVaultKeys < AzureGenericResources
  name 'azure_key_vault_keys'
  desc 'Verifies settings for a collection of Azure Keys belonging to a Vault'
  example <<-EXAMPLE
    describe azure_key_vault_keys(vault_name: 'vault-101') do
        it { should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    opts = { vault_name: opts } if opts.is_a?(String)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    opts[:allowed_parameters] = %i(is_uri_a_url vault_name audience)

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
    super(opts, true)
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
    table_schema = [
        { column: :kids, field: :kid },
        { column: :attributes, field: :attributes },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)

  end

  def to_s
    super(AzureKeyVault)
  end

  private

  # This is for backward compatibility.
  def populate_table
    return [] if @resources.empty?
    @resources.each do |resource|
      resource_instance = AzureResourceProbe.new(resource)
      # dm = AzureResourceDynamicMethods.new
      # dm.create_methods(resource_instance, resource[:attributes])
      @table << {
          kid: resource_instance&.kid,
          attributes: resource_instance&.attributes,
      }
    end
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermKeyVaultKeys < AzureKeyVaultKeys
  name 'azurerm_key_vault_keys'
  desc 'Verifies settings for a collection of Azure Keys belonging to a Vault'
  example <<-EXAMPLE
    describe azurerm_key_vault_keys('vault-101') do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureKeyVaultKeys.name)
    super
  end
end
