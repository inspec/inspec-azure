module Deprecations
  module StringsInWhereClause
    def self.included(base)
      base.class_eval do
        alias_method :old_where, :where

        def where(conditions = {}, &block)
          transformed = {}
          conditions.each do |key, value|
            if key.is_a? String
              warn '[DEPRECATION] String detected in where clause. As of verison 1.2 ' \
                'where clauses should use a symbol. Please convert ' \
                "where('#{key}' => '#{value}') to where(#{key}: '#{value}'). " \
                'Automatic conversion will be removed in version 2.0.'

              transformed[key.to_sym] = value
            else
              transformed[key] = value
            end
          end
          old_where(transformed, &block)
        end
      end
    end
  end
end
