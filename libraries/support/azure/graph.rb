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

    def user(id)
      get(
        "/#{tenant_id}/users/#{id}",
        params: { 'api-version' => '1.6' },
      )
    end

    def users
      get(
        "/#{tenant_id}/users",
        params: { 'api-version' => '1.6' },
      )
    end

    private

    def get(*args)
      confirm_configured!
      values = []

      response = rest_client.get(*args).body

      value = response.fetch('value', response)
      next_link = response.fetch('odata.nextLink', nil)

      # If it's a single entity being requested (e.g. a User), simply return the single entity.
      return value unless value.is_a?(Array)

      values += value

      # Get more if Graph API has paginated results.
      if !next_link.nil?
        loop do
          response = next_results(next_link)
          values += response.fetch('value', response)
          next_link = response.fetch('odata.nextLink', nil)
          break unless next_link
        end
      end
      values
    end

    def next_results(next_link)
      rest_client.get(
        "/#{tenant_id}/#{next_link}",
        params: { 'api-version' => '1.6' },
      ).body
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
