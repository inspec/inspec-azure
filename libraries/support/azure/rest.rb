# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

module Azure
  class Rest
    attr_reader :host, :resource, :credentials

    def initialize(client)
      @host        = client.base_url
      @resource    = client.base_url.to_s
      @resource    += '/' unless @resource[-1, 1] == '/'
      @credentials = client.credentials
    end

    def get(path, params: {}, headers: {})
      connection.get do |req|
        req.url path

        req.params  = req.params.merge(params)
        req.headers = req.headers.merge(headers)
        credentials.sign_request(req)
      end
    end

    def connection
      @connection ||= Faraday.new(url: host) do |conn|
        conn.request  :multipart
        conn.request  :json
        conn.request  :retry,
                      max:                 2,
                      interval:            0.05,
                      interval_randomness: 0.5,
                      backoff_factor:      2,
                      exceptions:          ['Timeout::Error']
        conn.response :json, content_type: /\bjson$/
        conn.adapter  Faraday.default_adapter
      end
    end

    def authorization_header
      @authentication ||= Authentication.new(
        *credentials.values_at(:tenant_id, :client_id, :client_secret), resource
      )
      @authentication.authentication_header
    end
  end
end
