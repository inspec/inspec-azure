require 'azure_generic_resource'

class AzureMigrateProjectDatabase < AzureGenericResource
  name 'azure_migrate_project_database'
  desc 'Retrieves and verifies the settings of an Azure Migrate Project Database.'
  example <<-EXAMPLE
    describe azure_migrate_project_database(resource_group: 'RESOURCE_GROUP_NAME', project_name: 'MIGRATE_PROJ_NAME', name: 'MIGRATE_PROJ_DB_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Migrate/assessmentProjects', opts)
    opts[:required_parameters] = %i(project_name)
    opts[:resource_path] = [opts[:project_name], 'groups'].join('/')
    super(opts, true)
    assessment_data_hash = properties.assessmentData.each_with_object(Hash.new { |h, k| h[k] = [] }) do |assessment_data, hash|
      assessment_data.each_pair { |key, value| hash[key.to_s.pluralize.to_sym] << value }
    end
    create_resource_methods(assessment_data_hash)
  end

  def to_s
    super(AzureMigrateProjectDatabase)
  end
end
