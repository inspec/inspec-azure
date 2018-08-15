# frozen_string_literal: true

module Azure
  class ResponseStruct
    def self.create(keys, values)
      Struct.new(*keys) do
        def key?(key)
          members.include?(key)
        end

        alias_method :keys, :members
      end.new(*values)
    end
  end
end
