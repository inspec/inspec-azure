require_relative '../../test_helper'
require_relative '../../../../libraries/support/azure/service'

describe TestCredentials do
  before do
    @service = Object.new
    @service.extend(Azure::Service)
  end

  it 'converts simple hashes to structs' do
    struct = @service.structify({ name: 'John', age: 20 })

    assert_equal('John', struct.name)
    assert_equal(20, struct.age)
  end

  it 'converts arrays to structs' do
    struct = @service.structify([{ name: 'John', age: 20 },
                                 { name: 'Jane', age: 25 }])

    assert_equal('John', struct[0].name)
    assert_equal(20, struct[0].age)
    assert_equal('Jane', struct[1].name)
    assert_equal(25, struct[1].age)
  end

  it 'converts complext hashes to structs' do
    struct = @service.structify({ name: 'John', age: 20,
                                 address: {
                                   street: '123 Fake st',
                                   city:   'Nowhere',
                                   state:  'NO',
                                 } })

    assert_equal('John', struct.name)
    assert_equal(20, struct.age)
    assert_equal('123 Fake st', struct.address.street)
    assert_equal('Nowhere', struct.address.city)
    assert_equal('NO', struct.address.state)
  end

  it 'handles empty hashes' do
    struct = @service.structify({ name: 'John', age: 20,
                                 address: {} })

    assert_equal('John', struct.name)
    assert_equal(20, struct.age)
    assert_equal({}, struct.address)
  end
end
