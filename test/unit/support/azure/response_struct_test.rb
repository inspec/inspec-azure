require_relative '../../test_helper'
require_relative '../../../../libraries/support/azure/response_struct'

describe Azure::ResponseStruct do
  let(:keys) { %i(foo bar baz) }
  let(:values) { %w{foo bar baz} }
  let(:data) { keys.zip(values).to_h }

  subject { Azure::ResponseStruct.create(keys, values) }

  it 'should produce a Struct' do
    expect(subject).must_be_kind_of Struct
  end

  it 'should respond to given keys' do
    keys.map { |key| expect(subject).must_respond_to key }
  end

  it 'should have expected values for given keys' do
    data.map { |key, value| expect(subject.send(key)).must_equal value }
  end

  it 'should return nil for unknown keys' do
    expect(subject.unknown_key).must_be_nil
  end

  describe 'should support some Hash methods' do
    it 'should support .key?()' do
      expect(subject).must_respond_to :key?

      expect(subject.key?(keys.first)).must_equal true
      expect(subject.key?(:unknown_key)).must_equal false
    end

    it 'should support .keys()' do
      expect(subject).must_respond_to :keys

      expect(subject.keys).must_equal keys

      expect(subject.keys).must_equal subject.members
    end
  end
end
