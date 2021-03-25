require 'azure_generic_resource'

class AzureCosmosDbGremlinResource < AzureGenericResource
  name 'azure_cosmosdb_gremlin_resource'
  desc 'Verifies settings for CosmosDb Database Account'
  example <<-EXAMPLE
    describe azure_cosmosdb_gremlin_resource(resource_group: 'example', name: 'my-cosmos-db-account')  do
      its('name') { should eq 'my-cosmos-db-account'}
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.DocumentDB/databaseAccounts', opts)
    opts[:resource_identifiers] = %i(cosmosdb_database_account cosmodb_gremlinDatabase_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureCosmosDbGremlinResource)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermCosmosDbGremlinResource < AzureCosmosDbGremlinResource
  name 'azurerm_cosmosdb_gremlin_resource'
  desc 'Verifies settings for CosmosDb Database Account'
  example <<-EXAMPLE
    describe azurerm_cosmosdb_database_account(resource_group: 'example', cosmosdb_database_account: 'my-cosmos-db-account')  do
      its('name') { should eq 'my-cosmos-db-account'}
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureCosmosDbGremlinResource.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2015-04-08'
    super
  end
end
