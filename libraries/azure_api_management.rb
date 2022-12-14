require "azure_generic_resource"

class AzureApiManagement < AzureGenericResource
  name "azure_api_management"
  desc "Verifies settings for an Azure Api Management Service"
  example <<-EXAMPLE
    describe azure_api_management(resource_group: 'rg-1', name: 'apim01') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.ApiManagement/service", opts)

    opts[:resource_identifiers] = %i(api_management_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureApiManagement)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermApiManagement < AzureApiManagement
  name "azurerm_api_management"
  desc "Verifies settings for an Azure Api Management Service"
  example <<-EXAMPLE
    describe azurerm_api_management(resource_group: 'rg-1', api_management_name: 'apim01') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureApiManagement.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= "2019-12-01"
    super
  end
end
