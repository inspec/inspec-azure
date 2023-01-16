require_relative "helper"
require "azure_graph_generic_resources"

class AzureGraphGenericResourcesConstructorTest < Minitest::Test
  # Generic resource requires `resource` parameter at least.
  def test_empty_params_not_ok
    assert_raises(ArgumentError) { AzureGraphGenericResources.new }
  end

  def test_not_allowed_parameter
    assert_raises(ArgumentError) { AzureGraphGenericResources.new(resource: "users", fake: "rubbish") }
  end

  def test_id_not_allowed
    assert_raises(ArgumentError) { AzureGraphGenericResources.new(resource: "users", id: "some_id") }
  end

  def test_filter_filter_free_text_together_not_allowed
    assert_raises(ArgumentError) do
      AzureGraphGenericResources.new(resource: "users",
                                     filter: { name: "some_id" }, filter_free_text: %w{some_filter})
    end
  end
end
