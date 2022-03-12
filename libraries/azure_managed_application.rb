require 'azure_generic_resource'

class AzureManagedApplication < AzureGenericResource
  name 'azure_managed_application'
  desc 'Retrieves and verifies the settings of an Azure Managed Application.'
  example <<-EXAMPLE
    describe azure_managed_application(resource_group: 'inspec-rg', name: 'app_name') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Solutions/applications', opts)
    super(opts, true)
  end

  def to_s
    super(AzureManagedApplication)
  end
end
