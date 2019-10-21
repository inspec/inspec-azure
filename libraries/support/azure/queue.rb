# frozen_string_literal: true

require 'azure/storage/queue'
require 'ostruct'

module Azure
  class Queue
    include Service

    def initialize(queue_name, backend)
      # FQDN per Queue, do not reuse client.
      backend.disable_cache(:api_call)

      @required_attrs = []
      @page_link_name = 'nextMarker'

      @rest_client    = Azure::Rest.new(client(queue_name, backend))
    end

    def queues
      get(
        url: '?comp=list',
        api_version: nil,
        use_cache: false,
        headers: {'x-ms-version' => '2017-11-09'}
      )
    end

    def queue_properties
      get(
        url: '/?restype=service&comp=properties',
        api_version: nil,
        use_cache: false,
        headers: {'x-ms-version' => '2017-11-09'}
      )
    end

    private

    attr_reader :rest_client

    def client(queue, backend)
      OpenStruct.new(
          {
            base_url: "https://#{queue}.queue.core.windows.net",
            credentials: auth_token(backend)
          })
    end

    def auth_token(backend)
      begin
        credentials = backend.instance_variable_get('@credentials')
        tenant = credentials[:tenant_id]
        client = credentials[:client_id]
        secret = credentials[:client_secret]
      rescue StandardError => e
        raise "Unable to load Azure Configuration from backend.\n #{e}"
      end

      settings = MsRestAzure::ActiveDirectoryServiceSettings.get_azure_settings
      settings.authentication_endpoint = 'https://login.microsoftonline.com/'
      settings.token_audience = 'https://storage.azure.com/'

      ::MsRest::TokenCredentials.new(::MsRestAzure::ApplicationTokenProvider.new(tenant, client, secret, settings))
    end


    def unwrap
      lambda do |body, _api_version|
      # TODO convert response to JSON/Hash
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
