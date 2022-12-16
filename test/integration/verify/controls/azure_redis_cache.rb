resource_group_name = attribute(:resource_group, value: nil)
inspec_redis_cache_name = attribute(:inspec_redis_cache_name, value: nil)

control "azure_redis_cache" do

  title "Testing the singular resource of azure_redis_cache."
  desc "Testing the singular resource of azure_redis_cache."

  describe azure_redis_cache(resource_group: resource_group_name, name: inspec_redis_cache_name) do
    it { should exist }
    it { should_not be_enabled_non_ssl_port }
    its("location") { should eq "East US" }
    its("properties.port") { should eq 6379 }
    its("properties.sslPort") { should eq 6380 }
    its("properties.redisConfiguration") { should have_attributes('maxmemory-policy': "volatile-lru") }
    its("properties.hostName") { should eq "inspec-compliance-redis-cache.redis.cache.windows.net" }
    its("properties.sku.name") { should eq "Standard" }
    its("properties.enableNonSslPort") { should eq false }
  end
end
