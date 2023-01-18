require "azure_generic_resource"

class AzureCDNProfile < AzureGenericResource
  name "azure_cdn_profile"
  desc "Verifies settings for a specific Azure CDN Profile."
  example <<-EXAMPLE
    describe azure_cdn_profile(resource_group: 'RESOURCE_GROUP_NAME', name: 'CDN_PROFILE_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.Cdn/profiles", opts)
    super(opts, true)
  end

  def to_s
    super(AzureCDNProfile)
  end
end
