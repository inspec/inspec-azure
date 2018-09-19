# frozen_string_literal: true

require 'singleton'

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
  end
end
