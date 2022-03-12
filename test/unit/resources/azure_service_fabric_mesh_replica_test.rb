require_relative 'helper'
require 'azure_service_fabric_mesh_replica'

class AzureServiceFabricMeshReplicaConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureServiceFabricMeshReplica.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureServiceFabricMeshReplica.new(resource_provider: 'some_type') }
  end

  def test_resource_group_name_alone_not_ok
    assert_raises(ArgumentError) { AzureServiceFabricMeshReplica.new(resource_group: 'test') }
  end
end
