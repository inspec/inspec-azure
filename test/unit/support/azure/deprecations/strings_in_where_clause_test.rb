require_relative '../../../test_helper'
require_relative '../../../../../libraries/support/azure/deprecations/strings_in_where_clause'

describe Azure::Deprecations::StringsInWhereClause do
  class DeprecatedExampleResource
    def where(conditions = {}, &_block)
      conditions
    end

    include Azure::Deprecations::StringsInWhereClause
  end

  let(:deprecated_resource) { DeprecatedExampleResource.new }
  let(:my_key)              { 'myKey' }
  let(:my_value)            { 'value' }
  let(:my_key_2)            { 'myKey2' }
  let(:my_value_2)          { 'value2' }
  let(:warning) do
    '[DEPRECATION] String detected in where clause. As of version 1.2 ' \
    'where clauses should use a symbol. Please convert ' \
    "where('#{my_key}' => '#{my_value}') to where(#{my_key}: '#{my_value}'). " \
    'Automatic conversion will be removed in version 2.0.'
  end

  it 'warns when a string is used in a where clause' do
    warn_message = ->(m) { assert_equal warning, m }

    deprecated_resource.stub(:warn, warn_message) do
      deprecated_resource.where(my_key => my_value) {}
    end
  end

  it 'converts the keys into symobls with strings given' do
    deprecated_resource.stub(:warn, 'ignored') do
      result = deprecated_resource.where({ my_key => my_value,
                                           my_key_2 => my_value_2 }) {}

      result.keys.each { |k| assert(k.is_a?(Symbol)) }
    end
  end

  it 'converts the string key into a symbol when string key given' do
    deprecated_resource.stub(:warn, 'ignored') do
      result = deprecated_resource.where(my_key => my_value) {}

      result.keys.each { |k| assert(k.is_a?(Symbol)) }
    end
  end

  it 'does not warn when a string is used in a where clause' do
    warn_message = ->(_) { flunk('No warning should be given') }

    deprecated_resource.stub(:warn, warn_message) do
      deprecated_resource.where(my_key.to_sym => my_value) {}
    end
  end
end
