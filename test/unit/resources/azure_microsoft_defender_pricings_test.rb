require_relative 'helper'
require 'azure_microsoft_defender_pricings'

class AzureMicrosoftDefenderPricingsTestConstructorTest < Minitest::Test
  def name_not_ok
    assert_raises(ArgumentError) { AzureMicrosoftDefenderPricings.new(name: 'some_tag_name') }
  end
end
