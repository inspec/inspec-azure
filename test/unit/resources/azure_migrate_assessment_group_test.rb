require_relative 'helper'
require 'azure_migrate_assessment_group'

class AzureMigrateAssessmentGroupConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureMigrateAssessmentGroup.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureMigrateAssessmentGroup.new(resource_provider: 'some_type') }
  end

  def test_resource_group_name_alone_ok
    assert_raises(ArgumentError) { AzureMigrateAssessmentGroup.new(name: 'my-name', resource_group: 'test') }
  end
end
