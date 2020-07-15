# frozen_string_literal: true

require "azurerm_resource"

class AzurermCosmoDbDatabaseAccount < AzurermSingularResource
  name "azurerm_cosmosdb_database_account"
  desc "Verifies settings for CosmosDb Database Account"
  example <<-EXAMPLE
    describe azurerm__cosmosdb_database_account(resource_group: 'example', cosmosdb_database_account: 'my-cosmos-db-account')  do
      its('name') { should eq 'my-cosmos-db-account'}
    end
  EXAMPLE

  ATTRS = %i{
    id
    name
    location
    type
    kind
    tags
    properties
  }.freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, cosmosdb_database_account: nil)
    resp = management.cosmosdb_database_account(resource_group, cosmosdb_database_account)

    return if has_error?(resp)

    assign_fields(ATTRS, resp)

    @exists = true
  end

  def to_s
    "'#{name}' CosmosDb Database Account"
  end
end
