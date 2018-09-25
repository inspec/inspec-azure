require_relative '../../test_helper'
require_relative '../../../../libraries/support/azure/service'

describe Azure::Service do
  let(:address)         { { street: '123 Fake St.', city: 'Nowhere', state: 'NO' } }
  let(:tags)            { { 'tag-1' => 'my-custom-tag', 'tag-2' => 'my-other-tag' } }
  let(:john)            { { name: 'John', age: 20, address: address } }
  let(:jane)            { { name: 'Jane', age: 25, address: {} } }
  let(:doe)             { { name: 'Doe', age: 30, address: {}, tags: tags } }
  let(:array_of_hashes) { [john, jane] }

  before do
    @service = Object.new.extend(Azure::Service)
  end

  it 'converts arrays to structs' do
    struct = @service.to_struct(array_of_hashes)

    assert_equal('John', struct[0].name)
    assert_equal(20, struct[0].age)
    assert_equal('Jane', struct[1].name)
    assert_equal(25, struct[1].age)
  end

  it 'converts complext hashes to structs' do
    struct = @service.to_struct(john)

    assert_equal('John', struct.name)
    assert_equal(20, struct.age)
    assert_equal('123 Fake St.', struct.address.street)
    assert_equal('Nowhere', struct.address.city)
    assert_equal('NO', struct.address.state)
  end

  it 'handles empty hashes' do
    struct = @service.to_struct(jane)

    assert_equal('Jane', struct.name)
    assert_equal(25, struct.age)
    assert_equal({}, struct.address)
  end

  it 'preserves tags key' do
    struct = @service.to_struct(doe)

    assert_equal(tags, struct.tags)
  end
end
