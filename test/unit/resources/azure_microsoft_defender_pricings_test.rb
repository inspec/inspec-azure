require_relative 'helper'
require 'azure_microsoft_defender_pricings'

class AzureDataFactoryLinkedServicesTestConstructorTest < Minitest::Test
  def test_resource_type_not_ok
    assert_raises(ArgumentError) { AzureMicrosoftDefenderPricings.new(resource_group: 'some_type') }
  end

  def name_not_ok
    assert_raises(ArgumentError) { AzureMicrosoftDefenderPricings.new(name: 'some_tag_name') }
  end
end
