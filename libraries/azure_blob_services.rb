require 'azure_generic_resources'

class AzureBlobServices< AzureGenericResources
  name 'azure_blob_services'
  desc 'Verifies settings for an Azure API Blob Services resource'
  example <<-EXAMPLE
    describe azure_blob_services(resource_group: 'resource-group-name', storage_account_name: "storage-account-name") do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Storage/storageAccounts', opts)
    opts[:required_parameters] = %i(storage_account_name)
    opts[:resource_path] = [opts[:storage_account_name], 'blobServices'].join('/')

    super(opts, true)

    return if failed_resource?
    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
    table_schema = [
      { column: :ids, field: :id },
      { column: :names, field: :name },
      { column: :types, field: :type },
      { column: :properties, field: :properties },
      { column: :skus, field: :sku },
    ]
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureBlobServices)
  end
end
