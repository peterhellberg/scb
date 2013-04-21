# encoding: utf-8

require 'uri'

require_relative "api/config"

module SCB
  class API
    attr_accessor :config

    def initialize(config = nil)
      @config = config || API::Config.new

      yield(@config) if block_given?
    end

    def get(path = nil)
      response = http_get(path)

      if response && response.body
        response.body.force_encoding('UTF-8')
      end
    end

    def get_and_parse(path = nil)
      load_json get(path)
    end

    def post(path, query)
      response = http_post path, dump_json(query)
      response_body_without_utf8_bom(query, response)
    end

    def post_and_parse(path, query)
      query.merge!({ response: { format: "json" }})
      load_json post(path, query)
    end

    def base_url
      config.base_url
    end

    def uri(endpoint = nil)
      URI.parse("#{base_url}/#{endpoint}")
    end

    def load_json(doc)
      config.json_parser.load(doc)
    end

    def dump_json(obj)
      config.json_parser.dump(obj)
    end

    private

    def response_body_without_utf8_bom(query, response)
      if query[:response] && query[:response][:format] == "json"
        # Force the response body to be UTF-8
        body = response.body.force_encoding('UTF-8')

        # Return the body, stripped of the BOM
        body.sub!(/^\xEF\xBB\xBF/, '')
      else
        response.body
      end
    end

    def http_get(path)
      config.http_client.get(uri(path))
    end

    def http_post(path, payload)
      config.http_client.post(uri(path), payload)
    end
  end
end
