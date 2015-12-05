module Todo
  module Src
    class File
      attr_reader :path, :mode

      def initialize(path, opts = {})
        @path = path
        @mode = opts[:mode] || 'w+'
      end

      def exists?
        ::File.exists?(path)
      end

      def read
        @lines ||= exists? ? ::File.readlines(path).map(&:rstrip) : []
      end

      def write(lines)
        ::File.open(path, mode) { |f| f.puts(lines.join("\n")) }
      end
    end
  end
end
