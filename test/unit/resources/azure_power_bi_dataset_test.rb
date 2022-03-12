require_relative 'helper'
require 'azure_power_bi_dataset'

class AzurePowerBIDatasetConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzurePowerBIDataset.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzurePowerBIDataset.new(resource_provider: 'some_type') }
  end

  def test_resource_group_name_alone_ok
    assert_raises(ArgumentError) { AzurePowerBIDataset.new(name: 'my-name', resource_group: 'test') }
  end
end
