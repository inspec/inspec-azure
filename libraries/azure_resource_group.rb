require 'azure_generic_resource'

class AzureResourceGroup < AzureGenericResource
  name 'azure_resource_group'
  desc 'Verifies settings for an Azure resource group.'
  example <<-EXAMPLE
    describe azure_resource_group(name: 'RESOURCE_GROUP_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('/resourcegroups/', opts)
    # See azure_policy_definitions resource for how to use `resource_uri` and `add_subscription_id` parameters.
    opts[:resource_uri] = '/resourcegroups/'
    opts[:add_subscription_id] = true

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureResourceGroup)
  end
end
