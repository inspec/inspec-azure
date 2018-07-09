# frozen_string_literal: true

require 'json'
require 'singleton'

module Azure
  class Graph
    include Singleton

    def with_client(graph_client, override: false)
      set_reader(:rest_client, graph_client, override)
    end

    def for_tenant(tenant_id, override: false)
      set_reader(:tenant_id, tenant_id, override)
    end

    def user(object_id)
      get(
          "/#{tenant_id}/users/#{object_id}",
          params: { 'api-version' => '1.6' }
      )
    end

    def users
      get(
          "/#{tenant_id}/users",
          params: { 'api-version' => '1.6' }
      )
    end

    def users_next(next_page)
      get(
          "/#{tenant_id}/#{next_page}",
          params: { 'api-version' => '1.6' }
      )
    end

    private

    def get(*args)
      confirm_configured!
      response          = rest_client.get(*args).body
      map               = {}
      map["values"]     = response.fetch('value', response)
      map["nextLink"] ||= response.fetch("odata.nextLink", nil)
      map
    end

    def confirm_configured!
      %i(rest_client tenant_id).each do |name|
        next if respond_to?(name)

        raise "Set #{name} before making requests"
      end
    end

    def set_reader(name, value, override)
      return self if respond_to?(name) && !override

      define_singleton_method(name) { value }

      self
    end
  end
end