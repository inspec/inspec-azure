require 'azure_generic_resource'

class AzureDataLakeStorageGen2Path < AzureGenericResource
  name 'azure_data_lake_storage_gen2_path'
  desc 'Retrieves and verifies the settings of a Data Lake Storage Gen2 file system'
  example <<-EXAMPLE
    describe azure_data_lake_storage_gen2_filesystem(account_name: 'ACCOUNT_NAME', filesystem: 'FILE_SYSTEM_NAME', name: 'FILE_SYSTEM_PATH_NAME') do
      it { should exist }
    end
  EXAMPLE

  API_VERSION = '2019-12-12'.freeze
  AUDIENCE = 'https://storage.azure.com/'.freeze
  RESOURCE = 'filesystem'.freeze
  HTTP_METHOD = 'head'.freeze
  DEFAULT_DFS = 'dfs.core.windows.net'.freeze

  attr_reader :table

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    Validators.validate_parameters(resource_name: @__resource_name__, required: %i(account_name filesystem name),
                                   allow: %i(dns_suffix action fsAction),
                                   opts: opts)
    account_name = opts.delete(:account_name)
    filesystem = opts.delete(:filesystem)
    path = [filesystem, opts[:name]].join('/')
    dns_suffix = opts.delete(:dns_suffix) || DEFAULT_DFS
    opts[:resource_uri] = "https://#{account_name}.#{dns_suffix}/#{path}"
    opts[:query_parameters] = {
      action: opts.delete(:action),
      fsAction: opts.delete(:fsAction),
    }
    opts[:headers] = {
      'X-ms-date': Time.now.strftime('%Y-%m-%d'),
      'X-ms-version': opts[:api_version] = API_VERSION,
    }
    opts[:method] = HTTP_METHOD
    opts[:audience] = AUDIENCE
    opts[:add_subscription_id] = false
    opts[:is_uri_a_url] = true
    opts[:transform_keys] = :underscore
    super
  end

  def to_s
    super(AzureDataLakeStorageGen2Path)
  end
end
