require_relative 'helper'
require 'azure_db_migration_service'

class AzureDBMigrationServiceConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureDBMigrationService.new }
  end

  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureDBMigrationService.new(resource_provider: 'some_type') }
  end
end
