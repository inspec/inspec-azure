require 'azure_generic_resource'

class AzureCosmosDbDatabaseAccount < AzureGenericResource
  name 'azure_cosmosdb_database_account'
  desc 'Verifies settings for CosmosDb Database Account'
  example <<-EXAMPLE
    describe azure_cosmosdb_database_account(resource_group: 'example', name: 'my-cosmos-db-account')  do
      its('name') { should eq 'my-cosmos-db-account'}
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.DocumentDB/databaseAccounts', opts)
    opts[:resource_identifiers] = %i(cosmosdb_database_account)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureCosmosDbDatabaseAccount)
  end
end
