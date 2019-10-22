# frozen_string_literal: true

require 'ostruct'
require 'json'
require 'active_support/core_ext/hash'

module Azure
  class Queue
    include Service

    def initialize(queue_name, backend)
      @required_attrs = []
      @page_link_name = 'nextMarker'
      @rest_client    = Azure::Rest.new(client(queue_name, backend))
    end

    def queues
      catch_404 do
        get(
          url: '?comp=list',
          headers: { 'x-ms-version' => '2017-11-09' },
          api_version: nil,
          unwrap: from_xml,
        )
      end
    end

    def queue_properties
      catch_404 do
        get(
          url: '/?restype=service&comp=properties',
          headers: { 'x-ms-version' => '2017-11-09' },
          api_version: nil,
          unwrap: from_xml,
        ).storage_service_properties
      end
    end

    private

    attr_reader :rest_client

    def client(queue, backend)
      OpenStruct.new(
        {
          base_url: "https://#{queue}.queue.core.windows.net",
          credentials: auth_token(backend),
        },
      )
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

    def from_xml
      result = {}
      lambda do |body, _api_version|
        # API returns XML.
        body = Hash.from_xml(body) unless body.is_a?(Hash)

        # Snake case recursively.
        body.each do |k, v|
          if v.is_a?(Hash)
            result[k.underscore] = from_xml.call(v, nil)
          else
            result[k.underscore] = v
          end
        end
        result
      end
    end

    def catch_404
      yield # yield
    rescue ::Faraday::ConnectionFailed
      # No such Queue.
      # Not all Storage Accounts have a Queue.
      nil
    end
  end
end
