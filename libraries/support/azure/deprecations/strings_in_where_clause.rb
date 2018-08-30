module Azure
  module Deprecations
    module StringsInWhereClause
      def self.included(base)
        base.class_eval do
          alias_method :filtertable_where, :where

          def where(conditions = {}, &block)
            string_warn = lambda do |k, v|
              warn_deprecation(k, v) if k.is_a?(String)
              [:"#{k}", v]
            end

            filtertable_where(conditions.map(&string_warn).to_h, &block)
          end

          def warn_deprecation(key, value)
            warn '[DEPRECATION] String detected in where clause. As of version 1.2 ' \
              'where clauses should use a symbol. Please convert ' \
              "where('#{key}' => '#{value}') to where(#{key}: '#{value}'). " \
              'Automatic conversion will be removed in version 2.0.'
          end
        end
      end
    end
  end
end
