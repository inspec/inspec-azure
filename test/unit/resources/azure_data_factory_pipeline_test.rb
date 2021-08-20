require_relative 'helper'
require 'azure_data_factory_pipeline'

class AzureDataFactoriesPipelineTestConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureDataFactory.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureDataFactoriesPipeline.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureDataFactoriesPipeline.new(name: 'my-name') }
  end
end
