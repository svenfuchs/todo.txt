module Todo
  module Src
    class Io
      attr_reader :opts

      def initialize(opts = {})
        @opts = opts
      end

      def read
        @lines ||= input.readlines.map(&:rstrip)
      end

      def write(lines)
        output.puts(lines.join("\n"))
      end

      private

        def input
          opts[:in] || $stdin
        end

        def output
          opts[:out] || $stdout
        end
    end
  end
end
