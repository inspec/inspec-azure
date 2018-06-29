# frozen_string_literal: true

module Azure
  class Authentication
    AUTH_PREFIX = 'https://login.microsoftonline.com'
    AUTH_SUFFIX = 'oauth2/token'

    def initialize(tenant_id, client_id, client_secret, resource)
      @host                 = "#{AUTH_PREFIX}/#{tenant_id}/#{AUTH_SUFFIX}"
      @resource             = resource
      @tenant_id            = tenant_id
      @client_id            = client_id
      @client_secret        = client_secret
      @token                = nil
      @expiration_threshold = 5 * 60
    end

    def authentication_header
      acquire_token if token_expired?

      "#{@token_type} #{@token}"
    end

    private

    def acquire_token
      data = {
        client_id:     @client_id,
        grant_type:    'client_credentials',
        client_secret: @client_secret,
        resource:      @resource,
      }

      body = connection.send(:post) do |req|
        req.url @host
        req.headers['content-type'] = 'application/x-www-form-urlencoded'
        req.body = URI.encode_www_form(data)
      end.body

      @token            = body['access_token']
      @token_expires_on = Time.at(Integer(body['expires_on']))
      @token_type       = body['token_type']
    end

    def connection
      @connection ||= Faraday.new(url: @host) do |conn|
        conn.request :retry,
                     max:                 2,
                     interval:            0.05,
                     interval_randomness: 0.5,
                     backoff_factor:      2,
                     exceptions:          ['Timeout::Error']
        conn.response :json, content_type: /\bjson$/
        conn.adapter  Faraday.default_adapter
      end
    end

    def token_expired?
      return true if @token.nil?

      Time.now >= @token_expires_on + @expiration_threshold
    end
  end
end
