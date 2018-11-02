# frozen_string_literal: true

module Azure
  class ResponseStruct
    def self.create(keys, values)
      Struct.new(*keys) do
        def key?(key)
          members.include?(key)
        end
        alias_method :keys, :members

        private

        def method_missing(_name)
          nil
        end
      end.new(*values)
    end
  end
end
