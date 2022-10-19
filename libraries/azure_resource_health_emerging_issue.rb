require 'azure_generic_resource'

class AzureResourceHealthEmergingIssue < AzureGenericResource
  name 'azure_resource_health_emerging_issue'
  desc 'Verifies a specific Azure service emerging issue'
  example <<-EXAMPLE
    describe azure_resource_health_emerging_issue(name: 'default') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ResourceHealth/emergingIssues', opts)
    opts[:resource_uri] = ['providers', opts[:resource_provider]].join('/')
    opts[:add_subscription_id] = false
    super(opts, true)
  end

  def to_s
    super(AzureResourceHealthEmergingIssue)
  end
end
