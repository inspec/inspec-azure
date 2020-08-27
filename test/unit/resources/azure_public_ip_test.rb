require_relative 'helper'
require 'azure_public_ip'

class AzurePublicIpConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzurePublicIp.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzurePublicIp.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzurePublicIp.new(name: 'my-name') }
  end
end
