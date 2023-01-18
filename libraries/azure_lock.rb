require "azure_generic_resource"

class AzureLock < AzureGenericResource
  name "azure_lock"
  desc "Verifies settings for an Azure Lock"
  example <<-EXAMPLE
    describe azure_lock(resource_group: 'RESOURCE_GROUP_NAME', name: 'LOCK_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)
    raise ArgumentError, "`resource_id` must be provided." if opts[:resource_id].nil?
    unless opts.slice(:name, :resource_group).keys.empty?
      raise ArgumentError, "`name` and `resource_group` parameters are not allowed."
    end

    opts[:resource_provider] = specific_resource_constraint("Microsoft.Authorization/locks", opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureLock)
  end
end
