# frozen_string_literal: true

require 'singleton'

module Azure
  class Graph
    include Singleton
    include Service

    def initialize
      @required_attrs = %i(backend)
      @page_link_name = 'odata.nextLink'
    end

    def user(id)
      get(
        url:           "/#{tenant_id}/users/#{id}",
        api_version:   '1.6',
        error_handler: handle_error,
        unwrap:        unwrap,
      )
    end

    def users
      get(
        url:           "/#{tenant_id}/users",
        api_version:   '1.6',
        error_handler: handle_error,
        unwrap:        unwrap,
      )
    end

    private

    attr_reader :page_link_name

    def rest_client
      if backend.msi_auth?
        raise Inspec::Exceptions::ResourceSkipped, 'MSI Authentication is currently unsupported for Active Directory Users.'
      end

      backend.enable_cache(:api_call)
      @rest_client ||= Azure::Rest.new(backend.azure_client(::Azure::GraphRbac::Profiles::Latest::Client))
    end

    def handle_error
      lambda do |response|
        if response.key?('odata.error')
          error = response['odata.error']
          message = "#{error['code']}: #{error.dig('message', 'value')}"
          raise Inspec::Exceptions::ResourceFailed, message
        end
      end
    end

    def next_page
      lambda do |url:, api_version:|
        body = rest_client.get(url, params: { 'api-version' => api_version }).body
        handle_error.call(body)
        values = body.fetch('value', body)
        link = body.fetch(page_link_name, nil)
        return [values, link]
      end
    end

    def unwrap
      lambda do |body, api_version|
        next_link = body.fetch(page_link_name, nil)
        values = body.fetch('value', body)
        return values unless values.is_a?(Array)

        until next_link.nil?
          records, next_link = next_page.call(url: "/#{tenant_id}/#{next_link}",
                                              api_version: api_version)
          values += records
        end

        values
      end
    end
  end
end
