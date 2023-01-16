require_relative "helper"
require "azure_blob_service"

class AzureBlobServiceConstructorTest < Minitest::Test
  # Generic resource requires a parameter.
  def test_empty_params_not_ok
    assert_raises(ArgumentError) { AzureBlobService.new }
  end

  def test_not_allowed_parameter
    assert_raises(ArgumentError) { AzureBlobService.new(resource: "domains", id: "some_id", fake: "random") }
  end

  def test_filter_not_allowed
    assert_raises(ArgumentError) { AzureBlobService.new(resource: "domains", id: "some_id", filter: "random") }
  end
end
