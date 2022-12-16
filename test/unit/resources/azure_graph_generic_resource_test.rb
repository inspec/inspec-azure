require_relative "helper"
require "azure_graph_generic_resource"

class AzureGraphGenericResourceConstructorTest < Minitest::Test
  # Generic resource requires a parameter.
  def test_empty_params_not_ok
    assert_raises(ArgumentError) { AzureGraphGenericResource.new }
  end

  def test_not_allowed_parameter
    assert_raises(ArgumentError) { AzureGraphGenericResource.new(resource: "users", id: "some_id", fake: "rubbish") }
  end

  def test_filter_not_allowed
    assert_raises(ArgumentError) { AzureGraphGenericResource.new(resource: "users", id: "some_id", filter: "rubbish") }
  end

  def test_resource_identifier_is_a_list
    assert_raises(ArgumentError) do
      AzureGraphGenericResource.new(resource: "users", id: "some_id",
                                    resource_identifier: "rubbish")
    end
  end
end
