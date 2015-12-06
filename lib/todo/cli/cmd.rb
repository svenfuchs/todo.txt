require 'todo/helpers/hash/slice'
require 'todo/src/file'
require 'todo/src/io'
require 'todo/support/options_parser'
require 'todo/view'

module Todo
  class Cli
    class Cmd < Struct.new(:args, :opts)
      extend Support::OptionsParser
      include Helpers::Hash::Slice

      opt '-f', '--file FILENAME', 'Filename' do |opts, file|
        opts[:file] = file
      end

      def io
        opts[:file] ? Src::File.new(opts[:file]) : Src::Io.new(slice(opts, :in, :out))
      end

      def render(list, cols = nil)
        View.new(list, cols).render
      end
    end
  end
end
