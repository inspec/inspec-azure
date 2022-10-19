require 'azure_generic_resources'

class AzureMigrateProjectDatabaseInstances < AzureGenericResources
  name 'azure_migrate_project_database_instances'
  desc 'Verifies settings for a collection of Azure Migrate Project Databases for a Azure Migrate Project in a Resource Group.'
  example <<-EXAMPLE
    describe azure_migrate_project_database_instances(resource_group: 'RESOURCE_GROUP_NAME', project_name: 'MIGRATE_PROJ_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Migrate/migrateProjects', opts)
    opts[:required_parameters] = %i(project_name)
    opts[:resource_path] = [opts[:project_name], 'databaseInstances'].join('/')
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureMigrateProjectDatabaseInstances)
  end

  private

  def populate_table
    @resources.each do |resource|
      resource = resource.merge(resource[:properties])
      discovery_data_hash = resource[:discoveryData].each_with_object(Hash.new { |h, k| h[k] = [] }) do |discovery_data, hash|
        discovery_data.each_pair { |key, value| hash[key.to_s.pluralize.to_sym] << value }
      end
      @table << resource.merge(discovery_data_hash)
    end
  end
end
