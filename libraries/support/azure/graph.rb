# frozen_string_literal: true

require 'singleton'

module Azure
  class Graph
    include Singleton
    include Service

    def initialize
      @required_attrs = %i(rest_client tenant_id)
      @page_link_name = 'odata.nextLink'
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

    attr_reader :page_link_name

    def format_error(error)
      "#{error['code']}: #{error.dig('message', 'value')}"
    end

    def get(*args)
      confirm_configured!
      values = []

      response = rest_client.get(*args).body # rest.get

      if response.key?('odata.error')
        raise Inspec::Exceptions::ResourceFailed, format_error(response['odata.error'])
      end

      value = response.fetch('value', response)
      next_link = response.fetch(page_link_name, nil)

      # If it's a single entity being requested (e.g. a User), simply return the single entity.
      return value unless value.is_a?(Array)

      values += value

      # Get more if Graph API has paginated results.
      if !next_link.nil?
        loop do
          response = next_results(next_link)
          values += response.fetch('value', response)
          next_link = response.fetch(page_link_name, nil)
          break unless next_link
        end
      end
      values
    end

    def next_results(next_link)
      rest_client.get( #rest.get
        "/#{tenant_id}/#{next_link}",
        params: { 'api-version' => '1.6' },
      ).body
    end
  end
end
