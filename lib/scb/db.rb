# encoding: utf-8

require_relative "db/level"
require_relative "db/table"
require_relative "db/variable"

module SCB
  class DB
    attr_accessor :api

    def initialize(api = nil)
      @api = api || SCB.api
    end

    def levels(klass = Level)
      @levels ||= data.map do |l|
        klass.new(l["id"], l["text"], api)
      end
    end

    def level(name, text = nil, klass = Level)
      klass.new(name, text, api)
    end

    def table(name, klass = Table)
      klass.new(name, api)
    end

    def uri
      api.uri
    end

    def en
      language('en')
    end

    def sv
      language('sv')
    end

    private

    def data
      api.get_and_parse
    end

    def language(language_code)
      api.config.language = language_code
      self
    end

    class InvalidQuery < RuntimeError
    end
  end
end
