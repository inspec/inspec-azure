require_relative 'helper'
require 'azure_microsoft_defender_setting'

class AzureMicrosoftDefenderSettingConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureMicrosoftDefenderSetting.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureMicrosoftDefenderSetting.new(resource_group: 'some_type') }
  end
end
