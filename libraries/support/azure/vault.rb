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
        url: '/keys',
        api_version: '2016-10-01',
        use_cache: false,
      )
    end

    def key(key_name, key_version)
      get(
        url: "/keys/#{key_name}/#{key_version}",
        api_version: '2016-10-01',
        use_cache: false,
      )
    end

    def key_versions(key_name)
      get(
        url: "/keys/#{key_name}/versions",
        api_version: '2016-10-01',
        use_cache: false,
      )
    end

    def secrets
      get(
        url: '/secrets',
        api_version: '2016-10-01',
        use_cache: false,
      )
    end

    def secret(secret_name, secret_version)
      get(
        url: "/secrets/#{secret_name}/#{secret_version}",
        api_version: '2016-10-01',
        unwrap: unwrap,
        use_cache: false,
      )
    end

    def secret_versions(secret_name)
      get(
        url: "/secrets/#{secret_name}/versions",
        api_version: '2016-10-01',
        use_cache: false,
      )
    end

    private

    def unwrap
      lambda do |body, _api_version|
        {
          id:           body.fetch('id'),
          value:        body.fetch('value'),
          attributes:   body.fetch('attributes'),
          kid:          body.fetch('kid', nil),
          content_type: body.fetch('contentType', nil),
          managed:      body.fetch('managed', false),
          tags:         body.fetch('tags', nil),
        }
      end
    end
  end
end
