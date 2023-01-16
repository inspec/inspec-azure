require_relative "helper"
require "azure_bastion_hosts_resources"

class AzureBastionHostsResourcesConstructorTest < Minitest::Test
  # resource_type should not be allowed.
  def test_resource_type_not_ok
    assert_raises(ArgumentError) { AzureBastionHostsResources.new(resource_provider: "some_type") }
  end

  def test_resource_id_not_ok
    assert_raises(ArgumentError) { AzureBastionHostsResources.new(resource_id: "some_id") }
  end

  def test_name_not_ok
    assert_raises(ArgumentError) { AzureBastionHostsResources.new(name: "some_name") }
  end
end
