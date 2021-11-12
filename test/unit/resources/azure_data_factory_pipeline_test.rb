require_relative 'helper'
require 'azure_data_factory_pipeline'

class AzureDataFactoryPipelineTestConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureDataFactoryPipeline.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureDataFactoryPipeline.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureDataFactoryPipeline.new(name: 'my-name') }
  end
end
