require 'azure_generic_resource'

class AzureApplicationGateway < AzureGenericResource
  name 'azure_application_gateway'
  desc 'Verifies settings for an Azure Application Gateway'
  example <<-EXAMPLE
    describe azure_application_gateway(resource_group: 'rg-1', name: 'lb-1') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/applicationGateways', opts)
    opts[:resource_identifiers] = %i(application_gateway_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureApplicationGateway)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermApplicationGateway < AzureApplicationGateway
  name 'azurerm_application_gateway'
  desc 'Verifies settings for an Azure Application Gateway'
  example <<-EXAMPLE
    describe azurerm_application_gateway(resource_group: 'rg-1', application_gateway_name: 'lb-1') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureApplicationGateway.name)
    super
  end
end
