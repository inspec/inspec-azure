require "azure_generic_resource"

class AzureDBMigrationService < AzureGenericResource
  name "azure_db_migration_service"
  desc "Verifies settings for a DB migration service resource in a resource group"
  example <<-EXAMPLE
    describe azure_db_migration_service(resource_group: 'RESOURCE_GROUP_NAME', service_name: 'DB_MIGRATION_SERVICE_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.DataMigration/services", opts)
    opts[:resource_identifiers] = %i(service_name)
    super(opts, true)
  end

  def to_s
    super(AzureDBMigrationService)
  end
end
