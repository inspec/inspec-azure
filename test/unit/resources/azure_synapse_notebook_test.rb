require_relative "helper"
require "azure_synapse_notebook"

class AzureSynapseNotebookConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureSynapseNotebook.new }
  end

  def test_endpoint_alone_not_ok
    assert_raises(ArgumentError) { AzureSynapseNotebook.new(endpoint: "https://analytics.dev.azuresynapse.net") }
  end

  def test_name_alone_not_ok
    assert_raises(ArgumentError) { AzureSynapseNotebook.new(name: "my-analytics-notebook") }
  end
end
