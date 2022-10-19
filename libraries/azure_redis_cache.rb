require 'azure_generic_resource'

class AzureRedisCache < AzureGenericResource
  name 'azure_redis_cache'
  desc 'Verifies settings for a redis cache resource in a resource group.'
  example <<-EXAMPLE
    describe azure_redis_cache(resource_group: 'RESOURCE_GROUP_NAME', name: 'CACHE_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Cache/redis', opts)
    opts[:resource_identifiers] = %i(name)
    super(opts, true)
  end

  def enabled_non_ssl_port?
    properties&.enableNonSslPort
  end

  def to_s
    super(AzureRedisCache)
  end
end
