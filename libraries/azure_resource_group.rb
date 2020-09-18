require 'azure_generic_resource'

class AzureResourceGroup < AzureGenericResource
  name 'azure_resource_group'
  desc 'Verifies settings for an Azure resource group'
  example <<-EXAMPLE
    describe azure_resource_group(name: 'my_resource_group_name') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('/resourcegroups/', opts)
    # GET https://management.azure.com/providers/Microsoft.Authorization/policyDefinitions/{policyDefinitionName}?api-version=2019-09-01
    opts[:resource_uri] = '/resourcegroups/'

    opts[:add_subscription_id] = true

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureResourceGroup)
  end
end
