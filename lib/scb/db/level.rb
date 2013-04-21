# encoding: utf-8

require_relative '../db'

module SCB
  class DB
    class Level
      attr_reader :name, :text, :api

      def initialize(name, text = nil, api = nil)
        @name = name
        @text = text
        @api  = api || SCB.api
      end

      def levels(klass = Level)
        @levels ||= objects_for_type(klass, "l")
      end

      def tables(klass = Table)
        @tables ||= objects_for_type(klass, "t")
      end

      def inspect
        name
      end

      private

      def objects_for_type(klass, type)
        data.map { |d|
          klass.new(d["id"], api) if d["type"] == type
        }.compact
      end

      def data
        @data ||= api.get_and_parse(name) || []
      end
    end
  end
end
