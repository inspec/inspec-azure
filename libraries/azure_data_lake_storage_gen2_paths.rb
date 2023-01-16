require "azure_generic_resources"

class AzureDataLakeStorageGen2Paths < AzureGenericResources
  name "azure_data_lake_storage_gen2_paths"
  desc "Verifies settings for a list of Data Lake Storage Gen2 Paths"
  example <<-EXAMPLE
    describe azure_data_lake_storage_gen2_paths(account_name: 'adls', filesystem: 'adls-filesystem') do
      it { should exist }
    end
  EXAMPLE

  API_VERSION = "2019-12-12".freeze
  AUDIENCE = "https://storage.azure.com/".freeze
  RESOURCE = "filesystem".freeze
  DEFAULT_DFS = "dfs.core.windows.net".freeze

  attr_reader :table

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    Validators.validate_parameters(resource_name: @__resource_name__, required: %i(account_name filesystem),
                                   allow: %i(dns_suffix recursive directory),
                                   opts: opts)
    account_name = opts.delete(:account_name)
    filesystem = opts.delete(:filesystem)
    dns_suffix = opts.delete(:dns_suffix) || DEFAULT_DFS
    opts[:resource_uri] = "https://#{account_name}.#{dns_suffix}/#{filesystem}"
    opts[:query_parameters] = {
      resource: RESOURCE,
      recursive: opts.delete(:recursive) || true,
      directory: opts.delete(:directory),
    }
    opts[:headers] = {
      'X-ms-date': Time.now.strftime("%Y-%m-%d"),
      'X-ms-version': opts[:api_version] = API_VERSION,
    }
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    super
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureDataLakeStorageGen2Paths)
  end

  private

  def populate_table
    @resources = @api_response[:paths]
    @table = @resources
  end
end
