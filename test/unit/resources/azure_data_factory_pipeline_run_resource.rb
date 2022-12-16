require_relative "helper"
require "azure_data_factory_pipeline_run_resource"

class AzureDataFactoryPipelineRunResourceTestConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureDataFactoryPipelineRunResource.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureDataFactoryPipelineRunResource.new(resource_provider: "some_type") }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureDataFactoryPipelineRunResource.new(name: "my-name") }
  end
end
