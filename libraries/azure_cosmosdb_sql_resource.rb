require 'azure_generic_resource'

class AzureCosmosDbSQLResource < AzureGenericResource
  name 'azure_cosmosdb_sql_resource'
  desc 'Verifies settings for CosmosDb SQL Resource'
  example <<-EXAMPLE
    describe azure_cosmosdb_sql_resource(resource_group: 'example', name: 'my-cosmos-db-account')  do
      its('name') { should eq 'my-cosmos-db-account'}
    end
  EXAMPLE
  #databaseAccounts/{accountName}/sqlDatabases/{databaseName}/containers/{containerName}?api-version=2020-04-01
  #/servers/{serverName}/databases/{databaseName}?api-version=2020-08-01-preview

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.DocumentDB/databaseAccounts', opts)
    opts[:required_parameters] = %i(cosmosdb_database_account)
    opts[:resource_path] = [opts[:cosmosdb_database_account], 'sqlDatabases', opts[:cosmosdb_sql_databasename], 'containers'].join('/')
    opts[:resource_identifiers] = %i(cosmosdb_containername)


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


#This code is working fine
# https://management.azure.com/subscriptions/subid/resourceGroups/rg1/providers/Microsoft.DocumentDB/databaseAccounts/ddb1/sqlDatabases/databaseName?api-version=2020-04-01
#   def initialize(opts = {})
#     raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

#     opts[:resource_provider] = specific_resource_constraint('Microsoft.DocumentDB/databaseAccounts', opts)
#     opts[:required_parameters] = %i(cosmosdb_database_account)
#     opts[:resource_path] = [opts[:cosmosdb_database_account], 'sqlDatabases'].join('/')
#     opts[:resource_identifiers] = %i(cosmosdb_sql_databasename)


#     opts[:allowed_parameters] = %i(auditing_settings_api_version
#                                   threat_detection_settings_api_version
#                                   encryption_settings_api_version)
#     opts[:allowed_parameters].each do |param|
#       opts[param] ||= 'latest'
#     end
#     # static_resource parameter must be true for setting the resource_provider in the backend.
#     super(opts, true)
#   end

#   def to_s
#     super(AzureCosmosDbSQLResource)
#   end
# end
# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermCosmosDbSQLResource < AzureCosmosDbSQLResource
  name 'azurerm_cosmosdb_sql_resource'
  desc 'Verifies settings for CosmosDb SQL Resource'
  example <<-EXAMPLE
    describe azurerm_cosmosdb_database_account(resource_group: 'example', cosmosdb_database_account: 'my-cosmos-db-account')  do
      its('name') { should eq 'my-cosmos-db-account'}
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureCosmosDbSQLResource.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2015-04-08'
    super
  end
end
