class AzureWebAppFunctions < AzureGenericResources
  name 'azure_web_app_functions'
  desc 'Verifies settings for a collection of Azure PostgreSQL Databases on a PostgreSQL Server'
  example <<-EXAMPLE
    describe azure_web_app_functions(resource_group: 'my-rg', site_name: "my-site") do
        it            { should exist }
        its('names')  { should_not be_empty }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Web/sites', opts)
    opts[:required_parameters] = %i(site_name)
    opts[:resource_path] = [opts[:site_name], 'functions'].join('/')

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
    table_schema = [
      { column: :names, field: :name },
      { column: :ids, field: :id },
      { column: :properties, field: :properties },
      { column: :types, field: :type },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureWebAppFunctions)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermWebAppFunctions < AzureWebAppFunctions
  name 'azurerm_web_app_functions'
  desc 'Verifies settings for Azure Web App Functions'
  example <<-EXAMPLE
    describe azure_web_app_functions(resource_group: 'my-rg', site_name: "my-site") do
      it{ should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureWebAppFunctions.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2018-02-01'
    super
  end
end