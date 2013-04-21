# encoding: utf-8

require_relative '../db'

module SCB
  class DB
    class Table
      attr_reader :name
      attr_accessor :api

      def initialize(name, api = nil)
        @name = name
        @api  = api || SCB.api
      end

      def query(simple_query, filter = "item")
        json_query parse_simple_query(simple_query, filter)
      end

      def json_query(search_query = {})
        body = post_query(search_query, "json")
        api.load_json(body) unless body.nil?
      end

      def png_query(simple_query, filter = "item")
        post_query parse_simple_query(simple_query, filter), "png"
      end

      def post_query(search_query, format = "json")
        api_post(name, {
          query: search_query,
          response: {
            format: format
          }
        })
      rescue SCB::HTTP::Exception
        raise SCB::DB::InvalidQuery, "Invalid query"
      end

      def title
        data['title']
      end

      def uri
        api_uri
      end

      def variables(klass = Variable)
        @variables ||= data['variables'].map do |v|
          klass.new(v)
        end
      end

      def codes
        variables.map(&:code)
      end

      def write_png_query(filename, simple_query, filter = "item")
        write_file filename, png_query(simple_query, filter)
      end

      def write_png_query_raw(filename, search_query)
        write_file filename, post_query(search_query, "png")
      end

      def inspect
        name
      end

      def data
        @data ||= api.get_and_parse(name) || []
      end

      private

      def api_uri
        api.uri(name)
      end

      def api_post(name, search_query)
        api.post(name, search_query)
      end

      def write_file(filename, data)
        unless File.exist?(filename)
          File.open(filename, 'wb') do |f|
            f.write data
          end
        end
      end

      def parse_simple_query(simple_query, filter)
        simple_query.map do |q|
          {
            code: q[0].to_s,
            selection: {
              filter: filter,
              values: Array(q[1]).map(&:to_s)
            }
          }
        end
      end
    end
  end
end
