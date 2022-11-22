require_relative 'helper'
require 'azure_microsoft_defender_settings'

class AzureDataFactoryLinkedServicesTestConstructorTest < Minitest::Test
  def test_resource_type_not_ok
    assert_raises(ArgumentError) { AzureMicrosoftDefenderSettings.new(resource_group: 'some_type') }
  end

  def name_not_ok
    assert_raises(ArgumentError) { AzureMicrosoftDefenderSettings.new(name: 'some_tag_name') }
  end
end
