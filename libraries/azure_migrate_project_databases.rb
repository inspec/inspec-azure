require 'azure_generic_resources'

class AzureMigrateProjectDatabases < AzureGenericResources
  name 'azure_migrate_project_databases'
  desc 'Verifies settings for a collection of Azure Migrate Project Databases for a Azure Migrate Project in a Resource Group'
  example <<-EXAMPLE
    describe azure_migrate_project_databases(resource_group: 'migrated_vms', project_name: 'zoneA_migrate_project') do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Migrate/migrateProjects', opts)
    opts[:required_parameters] = %i(project_name)
    opts[:resource_path] = [opts[:project_name], 'databases'].join('/')
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureMigrateProjectDatabases)
  end

  private

  def populate_table
    @resources.each do |resource|
      resource = resource.merge(resource[:properties])
      assessment_data_hash = resource[:assessmentData].each_with_object(Hash.new { |h, k| h[k] = [] }) do |assessment_data, hash|
        assessment_data.each_pair { |key, value| hash[key] << value }
      end
      @table << resource.merge(assessment_data_hash)
    end
  end
end
