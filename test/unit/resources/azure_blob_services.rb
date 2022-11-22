require_relative 'helper'
require 'azure_blob_services'

class AzureBlobServicesConstructorTest < Minitest::Test
  def test_not_allowed_parameter
    assert_raises(ArgumentError) { AzureBlobServices.new(resource: 'domains', fake: 'rubbish') }
  end

  def test_id_not_allowed
    assert_raises(ArgumentError) { AzureBlobServices.new(resource: 'domains', id: 'some_id') }
  end
end
