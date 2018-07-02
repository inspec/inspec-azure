# frozen_string_literal: true

module Azure
  class Credentials
    ATTRS = %i(subscription_id tenant_id client_id client_secret).freeze

    attr_reader(*ATTRS)

    def initialize(
      subscription_id: ENV['AZURE_SUBSCRIPTION_ID'],
      tenant_id:       ENV['AZURE_TENANT_ID'],
      client_id:       ENV['AZURE_CLIENT_ID'],
      client_secret:   ENV['AZURE_CLIENT_SECRET']
    )
      ATTRS
        .collect { |a| [a, binding.local_variable_get(a)] }
        .map(&ensure_values!)
        .map(&set_attrs)
    end

    def to_h
      ATTRS.zip(ATTRS.map { |a| send(a) }).to_h
    end

    def subscription_id=(id)
      raise 'subscription_id cannot be nil' if id.nil?

      @subscription_id = id
    end

    private

    def ensure_values!
      lambda do |v|
        raise "Expected value for #{v[0]} and none was found in the environment." if v[1].nil?

        v
      end
    end

    def set_attrs
      ->(v) { instance_variable_set("@#{v[0]}", v[1]) }
    end
  end
end
