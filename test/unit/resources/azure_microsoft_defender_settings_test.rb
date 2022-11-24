require_relative 'helper'
require 'azure_microsoft_defender_settings'

class AzureMicrosoftDefenderSettingsTestConstructorTest < Minitest::Test
  def name_not_ok
    assert_raises(ArgumentError) { AzureMicrosoftDefenderSettings.new(name: 'some_tag_name') }
  end
end
