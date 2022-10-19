require 'azure_generic_resource'

class AzureSQLManagedInstance < AzureGenericResource
  name 'azure_sql_managed_instance'
  desc 'Retrieves and verifies the settings of an Azure SQL Managed Instance.'
  example <<-EXAMPLE
    describe azure_sql_managed_instance(resource_group: 'RESOURCE_GROUP_NAME', name: 'inspec-sql-instance') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Sql/managedInstances', opts)
    super(opts, true)
  end

  def to_s
    super(AzureSQLManagedInstance)
  end
end
