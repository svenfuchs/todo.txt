require 'todo/helpers/hash/slice'
require 'todo/src/file'
require 'todo/src/io'
require 'todo/view'

module Todo
  module Cmd
    class Base < Struct.new(:args, :opts)
      include Helpers::Hash::Slice

      def io
        opts[:file] ? Src::File.new(opts[:file]) : Src::Io.new(slice(opts, :in, :out))
      end

      def render(list, cols = nil)
        View.new(list, cols).render
      end
    end
  end
end
