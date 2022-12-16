require "azure_generic_resources"

class AzureResourceHealthAvailabilityStatuses < AzureGenericResources
  name "azure_resource_health_availability_statuses"
  desc "Retrieves and verifies all availability statuses for a resource group"
  example <<-EXAMPLE
    describe azure_resource_health_availability_statuses do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.ResourceHealth/availabilityStatuses", opts)
    super(opts, true)

    return if failed_resource?

    table_schema = [
      { column: :ids, field: :id },
      { column: :names, field: :name },
      { column: :types, field: :type },
      { column: :properties, field: :properties },
      { column: :locations, field: :location },
    ]

    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureResourceHealthAvailabilityStatuses)
  end
end
