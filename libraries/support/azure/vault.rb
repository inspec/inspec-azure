# frozen_string_literal: true

module Azure
  class Vault
    include Service

    def initialize
      @required_attrs = %i(rest_client)
      @page_link_name = 'nextLink'
    end

    def keys
      get(
        false,
        url: '/keys',
        api_version: '2016-10-01',
      )
    end

    def key(key_name, key_version)
      get(
        false,
        url: "/keys/#{key_name}/#{key_version}",
        api_version: '2016-10-01',
      )
    end

    def key_versions(key_name)
      get(
        false,
        url: "/keys/#{key_name}/versions",
        api_version: '2016-10-01',
      )
    end

    def secrets
      get(
        false,
        url: '/secrets',
        api_version: '2016-10-01',
      )
    end

    def secret(secret_name, secret_version)
      get(
        false,
        url: "/secrets/#{secret_name}/#{secret_version}",
        api_version: '2016-10-01',
      )
    end

    def secret_versions(secret_name)
      get(
        false,
        url: "/secrets/#{secret_name}/versions",
        api_version: '2016-10-01',
      )
    end
  end
end
