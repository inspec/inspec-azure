resource_group_name = attribute(:resource_group, default: nil)

control 'azure redis caches test' do
  describe azure_redis_caches(resource_group: resource_group_name) do
    it { should exist }
    its('sku_names') { should include 'Standard' }
  end
end

control 'azure redis caches filters' do
  describe azure_redis_caches(resource_group: resource_group_name).where(enable_non_ssl_port: true) do
    it { should_not exist }
  end
end
