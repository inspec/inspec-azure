require_relative 'helper'
require 'azure_active_directory_domain_services'

class AzureActiveDirectoryDomainServicesConstructorTest < Minitest::Test
  def test_not_allowed_parameter
    assert_raises(ArgumentError) { AzureActiveDirectoryDomainServices.new(resource: 'domains', fake: 'rubbish') }
  end

  def test_id_not_allowed
    assert_raises(ArgumentError) { AzureActiveDirectoryDomainServices.new(resource: 'domains', id: 'some_id') }
  end

  def test_filter_filter_free_text_together_not_allowed
    assert_raises(ArgumentError) do
      AzureActiveDirectoryDomainServices.new(resource: 'domains',
                                             filter: { name: 'some_id' }, filter_free_text: %w{some_filter})
    end
  end
end
