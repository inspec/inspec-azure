class AzureWebAppFunction < AzureGenericResource
  name 'azure_web_app_function'
  desc 'Verifies settings and configuration for an Azure Function'
  example <<-EXAMPLE
    describe azure_web_app_function(resource_group: 'rg-1', name: '', function_name: '') do
      it            { should exist }
      its('name')   { should eq('') }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Web/sites', opts)
    opts[:required_parameters] = %i(site_name function_name)
    opts[:resource_path] = [opts[:site_name], 'functions'].join('/')
    opts[:resource_identifiers] = %i(site_name function_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureWebAppFunction)
  end
end
