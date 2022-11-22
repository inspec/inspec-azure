require_relative 'helper'
require 'azure_microsoft_defender_security_contact'

class AzureMicrosoftDefenderSecurityContactConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureMicrosoftDefenderSecurityContact.new }
  end
  
  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureMicrosoftDefenderSecurityContact.new(resource_group: 'some_type') }
  end
  
  def test_resource_group_name_not_ok
    assert_raises(ArgumentError) { AzureMicrosoftDefenderSecurityContact.new(name: 'security-contact-name', resource_group: 'test') }
  end
end
