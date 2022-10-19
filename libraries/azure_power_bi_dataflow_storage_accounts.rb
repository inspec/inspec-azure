require 'azure_power_bi_generic_resources'

class AzurePowerBIDataflowStorageAccounts < AzurePowerBIGenericResources
  name 'azure_power_bi_dataflow_storage_accounts'
  desc 'Retrieves and verifies the settings of all Azure Power BI Dataflow Storage Accounts.'
  example <<-EXAMPLE
    describe azure_power_bi_dataflow_storage_accounts do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    opts[:resource_path_array] = ['dataflowStorageAccounts']
    super
  end

  def to_s
    super(AzurePowerBIDataflowStorageAccounts)
  end
end
