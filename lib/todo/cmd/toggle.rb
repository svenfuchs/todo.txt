require 'todo/cmd/base'
require 'todo/data/list'
require 'todo/data/parser'

module Todo
  module Cmd
    class Toggle < Base
      def run
        list = Data::List.parse(io.read)
        list.toggle(data)
        io.write(render(list.items))
      end

      private

        def data
          data = Data::Parser.new(args.first).parse
          data = slice(data, :id, :text)
          data
        end
    end
  end
end
