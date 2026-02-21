require_relative 'helper'
require 'azure_network_private_endpoint'
require 'ostruct'

class AzureNetworkPrivateEndpointConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureNetworkPrivateEndpoint.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureNetworkPrivateEndpoint.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureNetworkPrivateEndpoint.new(name: 'my-name') }
  end

  def test_subnet_id
    resource = build_resource(
      OpenStruct.new(subnet: OpenStruct.new(id: 'subnet-id')),
    )

    assert_equal('subnet-id', resource.subnet_id)
  end

  def test_network_interface_ids
    resource = build_resource(
      OpenStruct.new(networkInterfaces: [OpenStruct.new(id: 'nic-1'), OpenStruct.new(id: 'nic-2')]),
    )

    assert_equal(%w{nic-1 nic-2}, resource.network_interface_ids)
  end

  def test_private_link_service_connection_ids
    resource = build_resource(
      OpenStruct.new(
        privateLinkServiceConnections: [
          OpenStruct.new(properties: OpenStruct.new(privateLinkServiceId: 'pls-1')),
          OpenStruct.new(properties: OpenStruct.new(privateLinkServiceId: nil)),
          OpenStruct.new(properties: OpenStruct.new(privateLinkServiceId: 'pls-2')),
        ],
      ),
    )

    assert_equal(%w{pls-1 pls-2}, resource.private_link_service_connection_ids)
  end

  def test_manual_private_link_service_connection_ids
    resource = build_resource(
      OpenStruct.new(
        manualPrivateLinkServiceConnections: [
          OpenStruct.new(properties: OpenStruct.new(privateLinkServiceId: 'manual-pls-1')),
          OpenStruct.new(properties: OpenStruct.new(privateLinkServiceId: nil)),
        ],
      ),
    )

    assert_equal(%w{manual-pls-1}, resource.manual_private_link_service_connection_ids)
  end

  def test_accessor_methods_return_nil_when_resource_does_not_exist
    resource = build_resource(nil, exists: false)

    assert_nil(resource.subnet_id)
    assert_nil(resource.network_interface_ids)
    assert_nil(resource.private_link_service_connection_ids)
    assert_nil(resource.manual_private_link_service_connection_ids)
  end

  private

  def build_resource(properties, exists: true)
    resource = AzureNetworkPrivateEndpoint.allocate
    resource.define_singleton_method(:exists?) { exists }
    resource.define_singleton_method(:properties) { properties }
    resource
  end
end
