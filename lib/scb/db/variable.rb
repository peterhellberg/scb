# encoding: utf-8

module SCB
  class DB
    class Variable
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def code
        data["code"]
      end

      def text
        data["text"]
      end

      def values
        data["values"]
      end

      def values_hash
        @values_hash ||= Hash[values.zip(value_texts)]
      end

      def value_texts
        data["valueTexts"]
      end

      def elimination?
        !!data["elimination"]
      end

      def time?
        !!data["time"]
      end
    end
  end
end
