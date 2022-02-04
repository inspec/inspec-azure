require 'azure_generic_resource'

class AzureKeyVaultSecrets < AzureGenericResources
  name 'azure_key_vault_secrets'
  desc 'Verifies settings for a collection of Azure Secrets within to a Vault'
  example <<-EXAMPLE
    describe azure_key_vault_secrets(vault_name: 'vault-101') do
        it { should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    opts = { vault_name: opts } if opts.is_a?(String)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:endpoint] ||= ENV_HASH['endpoint'] || 'azure_cloud'
    unless AzureEnvironments::ENDPOINTS.key?(opts[:endpoint])
      raise ArgumentError, "Invalid endpoint: `#{opts[:endpoint]}`."\
        " Expected one of the following options: #{AzureEnvironments::ENDPOINTS.keys}."
    end
    endpoint = AzureEnvironments.get_endpoint(opts[:endpoint])
    key_vault_dns_suffix = endpoint.key_vault_dns_suffix
    opts[:resource_provider] = specific_resource_constraint(key_vault_dns_suffix, opts)
    opts[:required_parameters] = %i(vault_name)
    opts[:resource_uri] = "https://#{opts[:vault_name]}#{key_vault_dns_suffix}/secrets"
    opts[:is_uri_a_url] = true
    opts[:audience] = "https://#{key_vault_dns_suffix.delete_prefix('.')}"
    super(opts, true)
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    # @see https://github.com/inspec/inspec/blob/master/dev-docs/filtertable-usage.md
    table_schema = [
      { column: :ids, field: :id },
      { column: :attributes, field: :attributes },
      { column: :contentTypes, field: :contentType },
      { column: :tags, field: :tags },
      { column: :managed, field: :managed },
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
        id: resource_instance&.id,
        attributes: resource_instance&.attributes,
        tags: resource_instance&.tags,
        contentType: resource_instance&.contentType,
        managed: resource_instance.managed,
      }
    end
  end
end
