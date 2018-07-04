# frozen_string_literal: true

require 'json'
require 'singleton'

module Azure
  class Graph
    include Singleton

    def initialize
      @user         = Hash.new { |h, k| h[k] = {} }
      @users        = {}
      @users_next   = {}
    end

    def with_client(azure_client, override: false)
      set_reader(:azure_client, azure_client, override)
    end

    def for_tenant(tenant_id, override: false)
      set_reader(:tenant_id, tenant_id, override)
    end

    def get_user(object_id)
      @user ||= get(
          "/#{tenant_id}/users/#{object_id}",
          params: { 'api-version' => '1.6' }
      )
    end

    def get_users
      @users ||= get(
          "/#{tenant_id}/users",
          params: { 'api-version' => '1.6' }
      )
    end

    def get_users_next(next_link)
      @users ||= get(
          "/#{tenant_id}/#{next_link}",
          params: { 'api-version' => '1.6', 'Users_ListNext' => '' }
          #todo Not sure if second param needed, docs are not clear.
      )
    end

    private

    def get(*args)
      confirm_configured!

      body = azure_client.get(*args).body
      body.fetch('value', body)
    end

    def confirm_configured!
      %i(azure_client tenant_id).each do |name|
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