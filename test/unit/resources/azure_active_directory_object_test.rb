require_relative 'helper'
require 'azure_active_directory_object'

class AzureActiveDirectoryObjectConstructorTest < Minitest::Test
  # Generic resource requires a parameter.
  def test_empty_params_not_ok
    assert_raises(ArgumentError) { AzureActiveDirectoryObject.new }
  end

  def test_not_allowed_parameter
    assert_raises(ArgumentError) { AzureActiveDirectoryObject.new(resource: 'directoryObjects', id: 'some_id', fake: 'random') }
  end

  def test_filter_not_allowed
    assert_raises(ArgumentError) { AzureActiveDirectoryObject.new(resource: 'directoryObjects', id: 'some_id', filter: 'random') }
  end

  def test_resource_identifier_is_a_list
    assert_raises(ArgumentError) do
      AzureActiveDirectoryObject.new(resource: 'directoryObjects', id: 'some_id',
                                     resource_identifier: 'random')
    end
  end
end
