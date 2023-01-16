require_relative "helper"
require "azure_synapse_notebooks"

class AzureSynapseNotebooksConstructorTest < Minitest::Test
  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureSynapseNotebooks.new(tag_value: "some_tag_value") }
  end

  def test_resource_id_not_ok
    assert_raises(ArgumentError) { AzureSynapseNotebooks.new(resource_id: "some_id") }
  end
end
