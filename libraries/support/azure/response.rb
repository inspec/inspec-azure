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

  class NullResponse
    def nil?
      true
    end
    alias empty? nil?

    def ==(other)
      other.nil?
    end
    alias === ==
    alias <=> ==

    def key?(_key)
      false
    end

    def method_missing(*_args)
      self
    end
  end
end
