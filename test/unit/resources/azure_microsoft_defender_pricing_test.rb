require_relative 'helper'
require 'azure_microsoft_defender_pricing'

class AzureMicrosoftDefenderPricingConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureMicrosoftDefenderPricing.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureMicrosoftDefenderPricing.new(resource_group: 'some_type') }
  end

  def test_resource_group_name_not_ok
    assert_raises(ArgumentError) { AzureMicrosoftDefenderPricing.new(name: 'VirtualMachines', resource_group: 'test') }
  end
end
