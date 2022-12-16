require "azure_generic_resource"

class AzureResourceHealthAvailabilityStatus < AzureGenericResource
  name "azure_resource_health_availability_status"
  desc "Retrieves and verifies availability status for a resource."
  example <<-EXAMPLE
    describe azure_resource_health_availability_status(resource_group: 'large_vms', resource_type: '',name: 'DemoExpensiveVM') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    resource_type = opts.delete(:resource_type)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.ResourceHealth/availabilityStatuses/current", opts)
    opts[:resource_uri] = ["resourcegroups", opts[:resource_group], "providers", resource_type, opts[:name],
                           "providers", opts[:resource_provider]].join("/")
    opts[:add_subscription_id] = true
    super(opts, true)
  end

  def to_s
    super(AzureResourceHealthAvailabilityStatus)
  end
end
