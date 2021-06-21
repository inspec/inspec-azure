require_relative 'helper'
require 'azure_db_migration_services'

class AzureDBMigrationServicesConstructorTest < Minitest::Test
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureDBMigrationServices.new(resource_provider: 'some_type') }
  end

  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureDBMigrationServices.new(tag_value: 'some_tag_value') }
  end

  def test_resource_id_not_ok
    assert_raises(ArgumentError) { AzureDBMigrationServices.new(resource_id: 'some_id') }
  end
end
