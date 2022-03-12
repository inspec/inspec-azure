resource_group_name = attribute(:resource_group, value: nil)

control 'azure redis caches test' do

  impact 1.0
  title 'Testing the plural resource of azure_redis_caches.'
  desc 'Testing the plural resource of azure_redis_caches.'

  describe azure_redis_caches(resource_group: resource_group_name) do
    it { should exist }
    its('sku_names') { should include 'Standard' }
  end

  describe azure_redis_caches(resource_group: resource_group_name).where(enable_non_ssl_port: true) do
    it { should_not exist }
  end
end
