require "azure_generic_resource"

class AzureSnapshot < AzureGenericResource
  name "azure_snapshot"
  desc "Retrieves and verifies the settings of an Azure Snapshot"
  example <<-EXAMPLE
    describe azure_snapshot(resource_group: 'rg-1', name: 'my-snapshot-name') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.Compute/snapshots", opts)
    opts[:resource_identifiers] = %i(snapshot_name)
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureSnapshot)
  end
end
