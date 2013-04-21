# encoding: utf-8

require "scb/api"
require "scb/db"
require "scb/http"
require "scb/version"

module SCB
  class << self
    def api(config = nil)
      API.new(config).tap do |a|
        yield(a.config) if block_given?
      end
    end

    def db(api = nil)
      @db ||= DB.new(api)
    end

    def level(name, text = nil, api = nil)
      DB::Level.new(name, text, api = nil)
    end

    def table(name, api = nil)
      DB::Table.new(name, api)
    end
  end
end
