require 'azure_generic_resource'

class AzureApiManagement < AzureGenericResource
  name 'azure_api_management'
  desc 'Verifies settings for an Azure Api Management Service'
  example <<-EXAMPLE
    describe azure_api_management(resource_group: 'rg-1', name: 'apim01') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ApiManagement/service', opts)

    opts[:resource_identifiers] = %i(api_management_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureApiManagement)
  end
end
