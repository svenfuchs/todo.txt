require 'todo/cli/cmd'
require 'todo/data/list'
require 'todo/data/parser'

module Todo
  class Cli
    class Toggle < Cmd
      def run
        list = Data::List.parse(io.read)
        list.toggle(data)
        io.write(render(list.items))
      end

      private

        def data
          data = Data::Parser.new(args.first).parse
          slice(data, :id, :text)
        end
    end
  end
end
