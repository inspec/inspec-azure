require 'azure_generic_resource'

class AzureCosmosDbMongoDBResource < AzureGenericResource
  name 'azure_cosmosdb_mongodb_resource'
  desc 'Verifies settings for CosmosDb MongoDB Resource'
  example <<-EXAMPLE
    describe azure_cosmosdb_mongodb_resource(resource_group: 'example', name: 'my-cosmos-db-account')  do
      its('name') { should eq 'my-cosmos-db-account'}
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.DocumentDB/databaseAccounts', opts)
    opts[:required_parameters] = %i(cosmosdb_database_account)
    opts[:resource_path] = [opts[:cosmosdb_database_account], 'mongodbDatabases'].join('/')
    opts[:resource_identifiers] = %i(cosmosdb_mongodb_databases_name)


    opts[:allowed_parameters] = %i(auditing_settings_api_version
                                  threat_detection_settings_api_version
                                  encryption_settings_api_version)
    opts[:allowed_parameters].each do |param|
      opts[param] ||= 'latest'
    end
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureCosmosDbSQLResource)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
# class AzurermCosmosDbMongoDBResource < AzureCosmosDbMongoDBResource
#   name 'azurerm_cosmosdb_mongodb_resource'
#   desc 'Verifies settings for CosmosDb MongoDB Resource'
#   example <<-EXAMPLE
#     describe azurerm_cosmosdb_database_account(resource_group: 'example', cosmosdb_database_account: 'my-cosmos-db-account')  do
#       its('name') { should eq 'my-cosmos-db-account'}
#     end
#   EXAMPLE

#   def initialize(opts = {})
#     Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureCosmosDbMongoDBResource.name)
#     # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
#     raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

#     # For backward compatibility.
#     opts[:api_version] ||= '2015-04-08'
#     super
#   end
# end
