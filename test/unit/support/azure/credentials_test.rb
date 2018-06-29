require_relative '../../test_helper'
require_relative '../../../../libraries/support/azure/credentials'

class TestCredentials < Minitest::Test
  def setup
    @attrs = %i(subscription_id tenant_id client_id client_secret)

    @hash = @attrs.zip(@attrs.collect { |a| "fake_#{a}" }).to_h

    @attrs.map { |a| ENV["AZURE_#{a}".upcase] = @hash[a] }

    @credentials = Azure::Credentials.new
  end

  def teardown
    @attrs.map { |a| ENV["AZURE_#{a}".upcase] = nil }
  end

  def test_defaults_to_env
    @attrs.each do |attr|
      assert_equal @credentials.send(attr), "fake_#{attr}"
    end
  end

  def test_generates_hash
    assert @credentials.to_h, @hash
  end
end
