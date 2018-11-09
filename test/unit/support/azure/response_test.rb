require_relative '../../test_helper'
require_relative '../../../../libraries/support/azure/response'

describe Azure::Response do
  let(:keys) { %i(foo bar baz) }
  let(:values) { %w{foo bar baz} }
  let(:data) { keys.zip(values).to_h }

  subject { Azure::Response.create(keys, values) }

  it 'should respond to given keys' do
    keys.map { |key| expect(subject).must_respond_to key }
  end

  it 'should have expected values for given keys' do
    data.map { |key, value| expect(subject.send(key)).must_equal value }
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

  describe Azure::NullResponse do
    let(:unknown_key) { subject.unknown_key }

    it 'should return null type for unknown keys' do
      expect(unknown_key).must_be_kind_of Azure::NullResponse
    end

    it 'should be nil' do
      expect(unknown_key).must_be :nil?
      expect(unknown_key.nil?).must_equal true
    end

    # rubocop: disable Style/NilComparison
    # rubocop: disable Style/CaseEquality
    it 'should always compare against nil as true' do
      expect(unknown_key == nil).must_equal true
      expect(unknown_key === nil).must_equal true
      expect(unknown_key <=> nil).must_equal true
    end
    # rubocop: enable Style/CaseEquality
    # rubocop: enable Style/NilComparison

    it 'should be empty' do
      expect(unknown_key).must_be :empty?
    end

    it 'should handle broken method chains' do
      expect(unknown_key.other_unknown_key).must_be :nil?
    end

    it 'should have no members' do
      expect(unknown_key.members).must_be :empty?
    end

    it 'should respond to index methods' do
      expect(unknown_key[:nothing]).must_be :nil?
    end
  end
end
