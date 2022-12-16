require_relative "helper"
require "azure_migrate_assessment_project"

class AzureMigrateAssessmentProjectConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureMigrateAssessmentProject.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureMigrateAssessmentProject.new(resource_provider: "some_type") }
  end

  def test_name_alone_ok
    assert_raises(ArgumentError) { AzureMigrateAssessmentProject.new(name: "my-name") }
  end
end
