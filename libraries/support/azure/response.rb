# frozen_string_literal: true

module Azure
  class Response
    def self.create(keys, values)
      Struct.new(*keys) do
        def key?(key)
          members.include?(key)
        end

        alias_method :keys, :members

        private

        def method_missing(*_args)
          NullResponse.new
        end
      end.new(*values)
    end
  end

  class NullResponse < Struct.new(:NullResponse)
    def nil?
      true
    end
    alias_method :empty?, :nil?

    def ==(other)
      other.nil?
    end
    alias_method :===, :==
    alias_method :<=>, :==

    def key?(_name)
      false
    end

    alias_method :keys, :members

    def method_missing(*_args)
      self
    end
  end
end
