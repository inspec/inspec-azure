# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

module Azure
  class Rest
    DEFAULT_HOST = 'https://management.azure.com'

    attr_reader :host, :resource, :credentials

    def initialize(host: DEFAULT_HOST, credentials: {})
      @host        = host
      @resource    = "#{host}/"
      @credentials = credentials
    end

    def get(path, params: {}, headers: {})
      connection.get do |req|
        req.url path

        req.params  = req.params.merge(params)
        req.headers = headers.merge(authorization: authorization_header)
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
