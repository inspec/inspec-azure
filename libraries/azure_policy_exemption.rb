require "azure_generic_resource"

class AzurePolicyExemption < AzureGenericResource
  name "azure_policy_exemption"
  desc "Retrieves and verifies policy exemption."
  example <<-EXAMPLE
    describe azure_policy_exemption(name: 'DemoExpensiveVM') do
      it { should exist }
    end

    describe azure_policy_exemption(resource_group: 'large_vms', name: 'DemoExpensiveVM') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.Authorization/policyExemptions", opts)
    opts[:resource_uri] = ["providers", opts[:resource_provider]].join("/") unless opts[:resource_group]
    opts[:add_subscription_id] = true
    super(opts, true)
  end

  def to_s
    super(AzurePolicyExemption)
  end
end
